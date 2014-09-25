# Code source de l'application

Le code source de l'application est accessible ici : https://github.com/titellus/geonetwork-cg84/

L'application est configurée pour le CG84 :
* configuration de la webapp
* connexion à la base
* configurer la carte :
 * consultation en JS (https://github.com/titellus/geonetwork-cg84/blob/stable-develop/web-client/src/main/resources/apps/search/js/map/Settings.js#L33), 
 * édition dans la console d'administration
* configurer le CSW pour INSPIRE (https://github.com/titellus/geonetwork-cg84/blob/stable-develop/web/src/main/webapp/xml/csw/capabilities_inspire.xml)


# Installation

Pré-requis :
* Java 1.7
* Tomcat 7
* Postgresql
* git et Maven 3 (pour compiler l'application uniquement)



## Configurer Tomcat

* Arrêter tomcat
* Créer une nouvelle base de données dans pgadmin
 * Se connecter avec l'utilisateur postgres
 * Créer un nouvelle base de données avec dans l'onglet définition, le modèle la base catalogue et le tablespace meta
*

Configurer Tomcat : Définir l'encodage dans le fichier conf/server.xml
```
<Connector ... URIEncoding="UTF-8">
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
* Créer
* Migrer la base de données (cf. https://github.com/titellus/geonetwork-cg84/tree/stable-develop/web/src/main/webapp/WEB-INF/classes/setup/sql-cg84)
* Lancer les instructions SQL de run-before-starting-the-app.sql (cf. )
* Configuration de la connexion à la base de données dans le fichier WAR
 * Dézipper le fichier geonetwork.war
 * Ouvrir le fichier WEB-INF/config-db/jdbc.properties
 * Modifier le fichier pour définir les variables username, password, database, host, port (cf. https://github.com/titellus/geonetwork-cg84/blob/stable-develop/web/src/main/webapp/WEB-INF/config-db/jdbc.properties).
 * Recréer le fichier WAR en rezippant les fichiers contenus dans le répertoire geonetwork
 * Modifier l'extension .zip en .war
* Déployer l'application dans Tomcat
 * Transférer l'application sur le serveur via WinSCP
 * Arrêter Tomcat
```
/etc/init.d/tomcat stop
```
 * Sauvegarder l'ancienne application (actuellement des liens symboliques) si besoin
```
cd /usr/local/apache-tomcat/webapps
rm geonetwork
rm intermap
```
 * Copier le fichier geonetwork.war dans le répertoire webapp de Tomcat
```
cp /disk/dist/catalogue/geonetwork.war .
```
* Démarrer l'application en lancant Tomcat
```
/etc/init.d/tomcat start
```
* Vérifier le bon démarrage de l'application
 * En base de données vérifier que l'application a bien crée les nouvelles tables dans la base catalogue
 * Connecter vous à http://
* Lancer les instructions SQL de run-after-starting-the-app.sql (cf. https://raw.githubusercontent.com/titellus/geonetwork-cg84/stable-develop/web/src/main/webapp/WEB-INF/classes/setup/sql-cg84/run-after-starting-the-app.sql)
* Relancer Tomcat
```
/etc/init.d/tomcat restart
```
 * Vérifier les paramètres http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/system
 * Définir le logo du catalogue http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/logo
 * Configurer le CSW http://localhost:8080/geonetwork/srv/fre/admin.console#/settings/csw


## Migrer les fiches ISO19139 profil France vers ISO19139 et amélioration de la conformité INSPIRE

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

## Reporter les imagettes dans la nouvelle installation


* Sauvegarder l'ancien répertoire de données
```
cd /usr/local
mv Catalogue Catalogue_bak
mkdir Catalogue
chown tomcat:tomcat Catalogue
```
* Configurer Tomcat pour utiliser le répertoire /usr/local/Catalogue/data. Ajouter les variables pour la configuration du répertoire des données dans bin/catalina.sh :
```
set JAVA_OPTS=%JAVA_OPTS% -Xms512m -Xmx512m -XX:MaxPermSize=512m
-Dgeonetwork.dir=/usr/local/Catalogue/data
-Dgeonetwork.schema.dir=/usr/local/apache-tomcat/webapps/geonetwork/WEB-INF/data/config/schema_plugins
-Dgeonetwork.codeList.dir=/usr/local/apache-tomcat/webapps/geonetwork/WEB-INF/data/config/codelist
```
* Relancer Tomcat
```
/etc/init.d/tomcat restart
```
* Copier les répertoires /usr/local/Catalogue/data/000xyz-00xyz dans le répertoire des données de la nouvelle version.
```
cd /usr/localt/Catalogue/data/data/metadata_data
cp -fr /usr/local/Catalogue_bak/data/00* .
chown -fR tomcat:tomcat *
```

* Ajuster les URL si besoins en SQL en base de données
```
UPDATE metadata SET data = replace(data, 'http://catalogue5.cg84.fr/catalogue', 'http://rt-pytheas.cg84.local:8080/catalogue')
WHERE data LIKE '%http://catalogue5.cg84.fr/catalogue%';
```


# Divers


* Configuration proxy



TODO: INSPIRE enabled


## Après la migration

* Lancer les instructions SQL de run-when-app-is-ok.sql si l'application a correctement été migrée.

