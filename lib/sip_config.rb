#!/usr/bin/env ruby
require "xcapclient"

include XCAPClient

class SIPConfig

  NS = {"pr"=>"urn:ietf:params:xml:ns:pres-rules", "cp"=>"urn:ietf:params:xml:ns:common-policy"}


  def prepare_xcap(user,buddies)

    xcap_conf = {
      :xcap_root => XCAP_ROOT,
      :user => user.sip_uri,
      :auth_user => user.username,
      :password => user.password,
      :ssl_verify_cert => SSL_VERIFY_CERT
    }

    xcap_apps = {
      "pres-rules" => {
        :xmlns => "urn:ietf:params:xml:ns:pres-rules",
        :mime_type => "application/auth-policy+xml",
        :document_name => "pres-rules"
      }
    }

    @client = Client.new(xcap_conf, xcap_apps)
    @client.application("pres-rules").add_document("index")
    pres_rules = build_xml(buddies).to_xml
    @client.application("pres-rules").document.plain = pres_rules

    # Why do we need this?
    @doc = @client.application("pres-rules").document
    reset_document(pres_rules)

  end

 def reset_document(pres_rules)
    @doc.plain = pres_rules
    @doc.etag = nil
    @client.put("pres-rules", nil, check_etag=false)  # Upload without cheking ETag.
  end  

  def build_xml(buddies)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.rulesets("xmlns:pr"=>"urn:ietf:params:xml:ns:pres-rules", "xmlns:cp"=>"urn:ietf:params:xml:ns:common-policy") {
        xml.parent.namespace = xml.parent.namespace_definitions.second
          xml['cp'].rules(:id => "pres_whitelist") {
            xml.conditions { 
              xml.identity{
                buddies.each do |sip_uri|
                  xml.one(:id => sip_uri)
                end
              }
            }
          }
      }
    end
  end

  def update_presence_rules(user, buddies)
    prepare_xcap(user, buddies)
    @client.put("pres-rules")
  end

  def show(text)
    puts "\n\n[#{name}] #{text}"
  end

end
