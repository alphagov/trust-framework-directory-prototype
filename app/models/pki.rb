require 'openssl'
require 'uri'
require 'base64'

class Pki
  attr_reader :root_ca, :root_key, :ocsp_host

  def initialize(_type = :RSA, cn = 'Trust Framework', ocsp_host = "http://the-future.gov.uk")
    @root_ca = load_root_ca(cn)
    @revoked_certificates = {}
    @ocsp_host = URI(ocsp_host)
  end

  def generate_root_certificate(cn)
    @root_key = OpenSSL::PKey::RSA.new 2048 # the CA's public/private key
    root_ca = OpenSSL::X509::Certificate.new
    root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
    root_ca.serial = take_next_serial
    root_ca.subject = OpenSSL::X509::Name.parse(
      "/DC=#{SecureRandom.alphanumeric}/DC=#{SecureRandom.alphanumeric}/CN=#{cn}"
    )
    root_ca.issuer = root_ca.subject # root CA's are "self-signed"
    root_ca.public_key = @root_key.public_key
    root_ca.not_before = Time.now
    root_ca.not_after = root_ca.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = root_ca
    ef.issuer_certificate = root_ca
    root_ca.add_extension(ef.create_extension("basicConstraints", "CA:TRUE", true))
    root_ca.add_extension(ef.create_extension("keyUsage", "keyCertSign, cRLSign", true))
    root_ca.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
    root_ca.add_extension(ef.create_extension("authorityKeyIdentifier", "keyid:always", false))
    root_ca.sign(@root_key, OpenSSL::Digest::SHA256.new)
  end

  def take_next_serial
    @serial_count ||= 0
    @serial_count += 1
  end

  def csr_to_cert(csr_pem)
    csr = OpenSSL::X509::Request.new(csr_pem)
    cert = OpenSSL::X509::Certificate.new
    cert.subject = csr.subject
    cert.public_key = csr.public_key
    cert.not_before = Time.now
    cert.not_after = root_ca.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity
    cert
  end

  def sign(cert, digest: 'SHA256')
    cert.issuer = root_ca.subject # root CA is the issuer
    cert.serial = take_next_serial
    cert.version = 2
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = cert
    ef.issuer_certificate = root_ca
    cert.add_extension(ef.create_extension("keyUsage", "digitalSignature", true))
    cert.add_extension(ef.create_extension("subjectKeyIdentifier", "hash", false))
    ocsp_extension = ef.create_extension("authorityInfoAccess", "OCSP;URI:#{@ocsp_host}")
    cert.add_extension(ocsp_extension)
    cert.sign(@root_key, "OpenSSL::Digest::#{digest}".constantize.new)
    cert
  end

  def generate_signed_cert(**args)
    if args[:digest].nil?
      sign(generate_cert(args))
    else
      sign(generate_cert(args), digest: args[:digest])
    end
  end

  def generate_encoded_cert(**args)
    Base64.strict_encode64(generate_signed_cert(args).to_der)
  end

  def generate_signed_ec_cert(period)
    cert, _key = *generate_ec_cert_and_key(expires_in: period)
    sign(cert)
  end

  def generate_signed_rsa_cert_and_key(**args)
    cert, public_key, private_key = *generate_rsa_cert_and_key(args)
    [self.sign(cert), public_key, private_key]
  end

  def revoke(certificate)
    @revoked_certificates[certificate.serial.to_i] = { time: Time.now, reason: 0 }
  end

  def revocation_data(serial)
    @revoked_certificates[serial.to_i]
  end

  def generate_cert(**args)
    generate_rsa_cert_and_key(args)[0]
  end

  def generate_rsa_cert_and_key(expires_in: 1.year, size: 2048, cn: "GENERATED TEST CERTIFICATE", digest: nil)
    key = OpenSSL::PKey::RSA.generate(size)
    generate_cert_using_key(key, expires_in, cn)
  end

  def generate_ec_cert_and_key(expires_in: 1.year, size: 2048, cn: "GENERATED TEST CERTIFICATE")
    ec_key = OpenSSL::PKey::EC.new('prime256v1').generate_key!
    point = ec_key.public_key
    key = OpenSSL::PKey::EC.new(point.group)
    key.public_key = point
    generate_cert_using_key(key, expires_in, cn)
  end

  def generate_cert_using_key(key, expires_in, cn)
    cert = OpenSSL::X509::Certificate.new
    cert.version = 3
    cert.subject = OpenSSL::X509::Name.parse "/DC=org/DC=TEST/CN=#{cn}"
    cert.public_key = key.public_key
    cert.not_before = Time.now - 5.years
    cert.not_after = Time.now + expires_in
    [cert, key.public_key, key]
  end

  def load_root_ca(cn)
    cert = Certificate.where(purpose: 'root').first

    if cert.nil?
      cert = Certificate.create(
        purpose: 'root',
        usage: 'signing',
        signed_certificate: generate_root_certificate(cn).to_pem,
        private_key: @root_key.to_s
      )
    else
      @root_key = OpenSSL::PKey::RSA.new(cert.private_key)
    end

    OpenSSL::X509::Certificate.new(cert.signed_certificate)
  end
end
