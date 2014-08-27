Ds::Spark.configure :development do
  wsdl 'http://sparkgatetest.interfax.ru/IfaxWebService/ifaxwebservice.asmx?WSDL'
  login 'ds_gate'
  password 'Vz3JW9h'
  cookies_expiration_time 60 * 5
end

Ds::Spark.configure :test do
  wsdl 'http://sparkgatetest.interfax.ru/IfaxWebService/ifaxwebservice.asmx?WSDL'
  login 'ds_gate'
  password 'Vz3JW9h'
  cookies_expiration_time 60 * 5
end

Ds::Spark.configure :staging do
  wsdl 'http://sparkgatetest.interfax.ru/IfaxWebService/ifaxwebservice.asmx?WSDL'
  login 'ds_gate'
  password 'Vz3JW9h'
  cookies_expiration_time 60 * 5
end

# TODO: Change to production credentials
Ds::Spark.configure :production do
  wsdl 'http://webservicefarm.interfax.ru/iFaxWebService/ifaxwebservice.asmx?WSDL'
  login 'DasredaGate'
  password 'OBCzyty'
  cookies_expiration_time 60 * 5
end
