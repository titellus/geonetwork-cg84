# Code source de l'application

Le code source de l'application est accessible ici : https://github.com/titellus/geonetwork-cg84/

L'application est configurée pour le CG84 :
* configuration de la webapp
* connexion à la base
* configurer la carte :
 * consultation en JS (https://github.com/titellus/geonetwork-cg84/blob/develop/web-client/src/main/resources/apps/search/js/map/Settings.js#L33), 
 * édition dans la console d'administration
* configurer le CSW pour INSPIRE (https://github.com/titellus/geonetwork-cg84/blob/develop/web/src/main/webapp/xml/csw/capabilities_inspire.xml)


# Installation

Pré-requis :
* Java 1.7
* Tomcat 7
* Postgresql
* git et Maven 3 (pour compiler l'application uniquement)

## Configurer Tomcat

Configurer Tomcat : Définir l'encodage dans le fichier conf/server.xml
```
<Connector ... URIEncoding="UTF-8">
```


Ajouter les variables pour la configuration du répertoire des données :
```
set JAVA_OPTS=%JAVA_OPTS% -Xms512m -Xmx512m -XX:MaxPermSize=512m
-Dgeonetwork.dir=/app/tomcat/data
-Dgeonetwork.schema.dir=/app/tomcat/webapps/geosource/WEB-INF/data/config/schema_plugins
-Dgeonetwork.codelist.dir=/app/tomcat/webapps/geosource/WEB-INF/data/config/codelist
```


## Compiler l'application (optionel)

 
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


## Migration de la base de données


* Sauvegarder la base de données
* Migrer la base de données (https://github.com/titellus/geonetwork-cg84/tree/develop/web/src/main/webapp/WEB-INF/classes/setup/sql-cg84)
* Lancer les instructions SQL de run-before-starting-the-app.sql
* Démarrer l'application
* Lancer les instructions SQL de run-after-starting-the-app.sql
* Copier les répertoires WEB-INF/data/000xyz-00xyz dans le répertoire des données de la nouvelle version.
* Démarrer l'application
 * Vérifier les paramètres http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/system
 * Définir le logo du catalogue http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/logo
 * Configurer le CSW http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/csw


## Migrer les fiches ISO19139 profil France vers ISO19139

* Sauvegarder la base !
* Se connecter avec un compte Admin
* Rechercher toutes les fiches à traiter http://localhost:8080/geonetwork/srv/fre/q?_isTemplate=y or n&summaryOnly=true
* Selectionner tout http://localhost:8080/geonetwork/srv/fre/metadata.select?selected=add-all
* Exécuter http://localhost:8080/geonetwork/srv/fre/metadata.batch.processing?process=cg84-fix
* Progress report http://localhost:8080/geonetwork/srv/fre/metadata.batch.processing.report
* Attendre la fin
* En base de donnée, lancer les instructions suivantes :

```
UPDATE catalogue.metadata SET schemaid = 'iso19139' WHERE schemaid = 'iso19139.fra';
```

* Vérifier la migration, en exécutant (qui doit retourner 0 résultat) :
```
SELECT * FROM catalogue.metadata WHERE data LIKE '%FRA_Dat%';
```

* Dans l'administration du catalogue > outils, réindexer le contenu.

## Après la migration

* Lancer les instructions SQL de run-when-app-is-ok.sql si l'application a correctement été migrée.

