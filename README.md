# Code source de l'application

Le code source de l'application est accessible ici : https://github.com/titellus/geonetwork-cg84/

L'application GéoSource est configurée pour le CG84 : 
* configuration de la webapp
 * connexion à la base (cf. https://github.com/titellus/geonetwork-cg84/blob/develop/web/src/main/webapp/WEB-INF/config-db/jdbc.properties)
* configurer la carte : 
 * consultation en JS (https://github.com/titellus/geonetwork-cg84/blob/develop/web-client/src/main/resources/apps/search/js/map/Settings.js#L33), 
 * édition dans la console d'administration
* configurer le CSW pour INSPIRE (https://github.com/titellus/geonetwork-cg84/blob/develop/web/src/main/webapp/xml/csw/capabilities_inspire.xml)


# Installation

Pré-requis :
* Java 1.7
* git et Maven 3 (pour compiler l'application uniquement)



* Configurer Tomcat : Définir l'encodage dans le fichier conf/server.xml
```
<Connector ... URIEncoding="UTF-8">
```
```
set JAVA_OPTS=%JAVA_OPTS% -Xms512m -Xmx512m -XX:MaxPermSize=512m -Dgeonetwork.dir=E:/LNS/REC/MET/Tomcat7.0/data -Dgeonetwork.schema.dir=E:/LNS/REC/MET/Tomcat7.0/webapps/geosource/WEB-INF/data/config/schema_plugins -Dgeonetwork.codelist.dir=E:/LNS/REC/MET/Tomcat7.0/webapps/geosource/WEB-INF/data/config/codelist
```


# Compiler l'application

 
```
git clone git@github.com:titellus/geonetwork-cg84.git
cd geonetwork-cg84
git submodule init
git submodule update
cp -R maven_repo/* ~/.m2/repository/.
export MAVEN_OPTS="-Xmx1024M -XX:MaxPermSize=1024M"
mvn clean install -DskipTests
```

Le WAR est alors disponible dans web/target/geonetwork.war.


# Migration


* Sauvegarder la base de données
* Migrer la base de données (https://github.com/titellus/geonetwork-cg84/tree/develop/web/src/main/webapp/WEB-INF/classes/setup/run.sql)


Copier le répertoire des données (ie. documents associés aux fiches, imagettes) dans la nouvelle version.
Copier les répertoires WEB-INF/data/000xyz-00xyz dans le répertoire des données de la nouvelle version.


## Migrer les fiches ISO19139 profil France vers ISO19139

* Sauvegarder la base !
* Se connecter avec un compte Admin
* Rechercher toutes les fiches à traiter (eg. schema iso19139.fra) http://localhost:8080/geonetwork/srv/eng/q?_schema=iso19139.fra&_isTemplate=y or n&summaryOnly=true
* Selectionner tout http://localhost:8080/geonetwork/srv/eng/metadata.select?selected=add-all
* Exécuter http://localhost:8080/geonetwork/srv/eng/metadata.batch.processing?process=to19139
* Progress report http://localhost:8080/geonetwork/srv/eng/metadata.batch.processing.report
* Attendre la fin
* En base de donnée

```
UPDATE metadata SET schemaid = 'iso19139' WHERE schemaid = 'iso19139.fra';
```

Vérifier la migration
```
select * from metadata where data like '%FRA_Dat%'
```


* Dans l'administration du catalogue, réindexer le contenu.
