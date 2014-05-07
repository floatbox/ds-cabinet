Ds::Spark.configure :development do
  wsdl 'http://sparkgatetest.interfax.ru/IfaxWebService/ifaxwebservice.asmx?WSDL'
  login 'ds_gate'
  password 'Vz3JW9h'
end

Ds::Spark.configure :staging do
  wsdl 'http://webservicefarm.interfax.ru/iFaxWebService/ifaxwebservice.asmx?WSDL'
  login 'DasredaGate'
  password 'OBCzyty'
end

# TODO: Change to production credentials
Ds::Spark.configure :production do
  wsdl 'http://sparkgatetest.interfax.ru/IfaxWebService/ifaxwebservice.asmx?WSDL'
  login 'ds_gate'
  password 'Vz3JW9h'
end