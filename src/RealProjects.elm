module RealProjects exposing (..)

type alias RealProject =
  { name : String
  , category : String
  , initialRelease : DateString
  , writtenIn : String
  , description : String
  , link : String
  }

default : RealProject
default =
  { name = ""
  , category = ""
  , initialRelease = ""
  , writtenIn = ""
  , description = ""
  , link = ""
  }

type alias DateString = String

projects : List RealProject
projects =
  List.map
    (\name ->
      { name = name
      , category = ""
      , initialRelease = ""
      , writtenIn = ""
      , description = ""
      , link = ""
      })
    (String.lines namesString)

namesString : String
namesString = """.NET Ant Library
Abdera
Accumulo
ACE
ActiveMQ
AGE
Airavata
Airflow
Allura
Ambari
Anakia
Annotator
Ant
AntUnit
Any23
Apex
APISIX
Archiva
Aries
Arrow
AsterixDB
Atlas
Avro
Axiom
Axis2
Bahir
Batik
Beam
Beehive
Bigtop
Bloodhound
BlueMarlin
BookKeeper
Brooklyn
brpc
Buildr
BVal
Calcite
Camel
CarbonData
Cassandra
Cayenne
Celix
Chainsaw
Chemistry
Chukwa
Clerezza
Click
CloudStack
Cocoon
Commons BCEL
Commons BeanUtils
Commons BSF
Commons Chain
Commons CLI
Commons Codec
Commons Collections
Commons Compress
Commons Configuration
Commons Crypto
Commons CSV
Commons Daemon
Commons DBCP
Commons DbUtils
Commons Digester
Commons Email
Commons Exec
Commons FileUpload
Commons Functor
Commons Geometry
Commons HttpClient
Commons Imaging
Commons IO
Commons JCI
Commons JCS
Commons Jelly
Commons JEXL
Commons JXPath
Commons Lang
Commons Logging
Commons Math
Commons Net
Commons Numbers
Commons OGNL
Commons Pool
Commons Proxy
Commons RDF
Commons RNG
Commons SCXML
Commons Statistics
Commons Text
Commons Validator
Commons VFS
Commons Weaver
Community Development
Compress Ant Library
Continuum
Cordova
CouchDB
Crail
Crunch
cTAKES
Curator
CXF
Daffodil
DataFu
DataFu
DataLab
DataSketches
Deltacloud
DeltaSpike
Derby
DeviceMap
DirectMemory
Directory
Directory Server
Directory Studio
DolphinScheduler
Doris
Drill
Druid
Dubbo
ECharts
ECS
Empire-db
ESME
Etch
EventMesh
Excalibur
Falcon
Felix
Fineract
Flagon
Flex
Flink
Flume
Fluo
Fluo Recipes
Fluo YARN
FOP
Forrest
Fortress
FreeMarker
FreeMarker
FtpServer
Geode
Geronimo
Giraph
Gobblin
Gora
Griffin
Groovy
Guacamole
Gump
Hadoop
Hama
Harmony
HAWQ
HBase
Helix
Heron
Hive
Hivemall
Hivemind
Hop
HTTP Server
HttpComponents Client
HttpComponents Core
Hudi
Iceberg
Ignite
Impala
InLong
IoTDB
IoTDB
Isis
Ivy
IvyDE
Jackrabbit
Jakarta Cactus
JAMES
jclouds
Jena
JMeter
Johnzon
Joshua
JSPWiki
Juneau
Kafka
Karaf
Kerby
Kibble
Knox
Kudu
Kylin
Kyuubi
Lens
Lenya
Libcloud
Liminal
Linkis
Livy
log4cxx
Log4j 2
log4net
log4php
Lucene Core
Lucene.Net
Lucy
MADlib
Mahout
ManifoldCF
Marmotta
Marvin-AI
Maven
Maven Doxia
Mesos
MetaModel
Milagro
MINA
Mnemonic
mod_ftp
mod_perl
MRUnit
MXNet
MyFaces
Mynewt
Nemo
NetBeans
NiFi
NLPCraft
Nutch
NuttX
ODE
OFBiz
Olingo
Oltu - Parent
OODT
Oozie
Open Climate Workbench
OpenJPA
OpenMeetings
OpenNLP
OpenOffice
OpenWebBeans
OpenWhisk
ORC
ORO
Ozone
PageSpeed
Parquet
PDFBox
Pegasus
Petri
Phoenix
Pig
Pinot
Pivot
PLC4X
POI
Polygene
Pony Mail
Portable Runtime
Portals
PredictionIO
Props Ant Library
Pulsar
PyLucene
Qpid
Ranger
Rat
Ratis
REEF
Regexp
River
Rivet
RocketMQ
Roller
Royale
Rya
Samza
Sandesha2
Santuario
Scout
SDAP
Sedona
Serf
ServiceComb
ServiceMix
Shale
ShardingSphere
ShenYu
Shindig
Shiro
SINGA
SkyWalking
Sling
Solr
Solr Operator
SpamAssassin
Spark
Spatial Information System
Spot
Sqoop
SSHD
Stanbol
Steve
Storm
Stratos
StreamPipes
Streams
Struts
Submarine
Subversion
Superset
Synapse
Syncope
SystemDS
Tajo
Tapestry
Teaclave
Tentacles
Texen
Tez
Thrift
Tika
Tiles
TinkerPop
Tobago
Tomcat
TomEE
Toree
Torque
Traffic Control
Traffic Server
Trafodion
Training
Turbine
Tuscany
Tuweni
TVM
UIMA
Unomi
Usergrid
VCL
Velocity
Velocity DVSL
Velocity Tools
VSS Ant Library
VXQuery
Vysper
Wayang
Websh
Whimsy
Whirr
Whisker
Wicket
Wink
Woden
Wookie
Xalan for C++ XSLT Processor
Xalan for Java XSLT Processor
Xerces for C++ XML Parser
Xerces for Java XML Parser
Xerces for Perl XML Parser
Xindice
XML Commons External
XML Commons Resolver
XML Graphics Commons
XMLBeans
Yetus
YuniKorn
Zeppelin
ZooKeeper"""
