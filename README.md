# Code source de l'application

Le code source de l'application est accessible ici : https://github.com/titellus/geonetwork-cg84/

L'application est configurée pour la plateforme cible du CG84 :
* configuration de la webapp au format WAR
* configuration de Tomcat pour simplifier les mises à jour (avec configuration du répertoire des données)
* connexion à la base de données
* configuration du fond de carte (https://github.com/titellus/geonetwork-cg84/blob/stable-develop/web-client/src/main/resources/apps/search/js/map/Settings.js#L33)
* configuration du service de découverte CSW pour INSPIRE (https://github.com/titellus/geonetwork-cg84/blob/stable-develop/web/src/main/webapp/xml/csw/capabilities_inspire.xml)
* initialisation :
 * des logos par défaut
 * des thésaurus



# Installation

L'installation est réalisée sur la plateforme du CG84 qui dispose déjà des pré-requis suivant :
* Java 1.7
* Tomcat 7
* Postgresql
* git et Maven 3 (pour compiler l'application uniquement)


## Compiler l'application (optionel)

Il est possible de créer le WAR à partir des sources de l'application. Pour cela, réaliser les actions suivantes :
 
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


## Configurer Tomcat

Tomcat est installé dans le répertoire /usr/local/apache-tomcat/.


* Arrêter tomcat
```
/etc/init.d/tomcat stop
```


* Vérifier la configuration de Tomcat pour l'encodage du connecteur HTTP. L'encodage est défini dans le fichier conf/server.xml dans les éléments Connector. UTF-8 doit être utilisé :
```
<Connector ... URIEncoding="UTF-8">
```
* Configurer Tomcat pour utiliser le répertoire /usr/local/Catalogue/data pour le stockage des données du catalogue (ie. logos, thésaurus, données associées aux fiches). Ajouter les variables pour la configuration du répertoire des données dans bin/catalina.sh :
```
set JAVA_OPTS=%JAVA_OPTS% -Xms512m -Xmx512m -XX:MaxPermSize=512m
-Dgeonetwork.dir=/usr/local/Catalogue/data
-Dgeonetwork.schema.dir=/usr/local/apache-tomcat/webapps/geonetwork/WEB-INF/data/config/schema_plugins
```
* Eventuellement ajuster la mémoire utilisée en fonction du serveur (eg. 512m est un minimum, -Xmx1g peut être souhaitable)


## Créer le répertoire des données

* Sauvegarder l'ancien répertoire et créer le nouveau répertoire :
```
cd /usr/local
mv Catalogue Catalogue_bak
mkdir Catalogue
chown tomcat:tomcat Catalogue
```



## Créer la base de données

Créer une nouvelle base de données dans pgadmin
* Se connecter avec l'utilisateur postgres
* Créer un nouvelle base de données à partir d'un modèle (cf. onglet définition) afin de dupliquer la base de l'installation actuelle. Utiliser le tablespace meta comme pour la version actuelle.
* veiller à ce que l'utilisateur catalogue ait bien les droits de création de table dans la base.


## Migrer la base de données

Vue la version ancienne de la base de données actuelle (2.4) et le grand nombre de changement dans le modèle de données, la migration consiste en :
* création d'une copie des tables de la version 2.4
* lancement de l'application pour créer le modèle de données de la version 2.11
* transfert et ajustement des données des tables de la 2.4 vers les tables de la 2.11.


Pour cela, réaliser les actions suivantes :

* Sauvegarder la base de données
* Se connecter dans pgadmin à la base de données créée dans l'étape précédente
* Migrer la base de données via pgadmin et son module SQL (cf. https://github.com/titellus/geonetwork-cg84/tree/stable-develop/web/src/main/webapp/WEB-INF/classes/setup/sql-cg84)
* Lancer les instructions SQL de run-before-starting-the-app.sql (cf. https://github.com/titellus/geonetwork-cg84/tree/stable-develop/web/src/main/webapp/WEB-INF/classes/setup/sql-cg84/run-before-starting-the-app.sql)
* Configurer la connexion à la base de données dans le fichier WAR dans le répertoire WEB-INF/config-db/jdbc.properties
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
 * Sauvegarder l'ancienne application si besoin (actuellement des liens symboliques)
```
cd /usr/local/apache-tomcat/webapps
rm geonetwork
rm intermap
```
 * Copier le fichier geonetwork.war dans le répertoire webapps de Tomcat
```
cp /disk/dist/catalogue/geonetwork.war .
```
* Démarrer l'application en lancant Tomcat
```
/etc/init.d/tomcat start
```
* Vérifier le bon démarrage de l'application
 * En base de données vérifier que l'application a bien créée les nouvelles tables dans la base catalogue
 * Connecter vous à http://localhost:8080/geonetwork
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
SELECT * FROM catalogue.metadata WHERE data LIKE '%FRA_DataIdentification%';
```

* Dans l'administration du catalogue > outils, réindexer le contenu.

## Reporter les imagettes dans la nouvelle installation

Copier les répertoires /usr/local/Catalogue/data/000xyz-00xyz dans le répertoire des données de la nouvelle version.
```
cd /usr/local/Catalogue/data/data/metadata_data
cp -fr /usr/local/Catalogue_bak/data/00* .
chown -fR tomcat:tomcat *
```
* (a priori, non nécessaire en production) Ajuster les URL si besoin en SQL en base de données:
```
UPDATE catalogue.metadata SET data = replace(data, 'http://catalogue5.cg84.fr/catalogue', 'http://rt-pytheas.cg84.fr:8080/geonetwork')
WHERE data LIKE '%http://catalogue5.cg84.fr/catalogue%';
```

## Après la migration

* Lancer les instructions SQL de run-when-app-is-ok.sql si l'application a correctement été migrée pour supprimer les tables temporaires de la version 2.4..


# Divers

* Configuration proxy Java via les variables d'environnement Java (cf. http://docs.oracle.com/javase/7/docs/api/java/net/doc-files/net-properties.html)
* Comment dupliquer la production en recette ?
 * Faire un backup de la base de données
 * Recharger le backup en recette
 * Transférer le répertoire des données (/usr/local/Catalogue) de la production vers la recette
 * Transférer l'application web (WAR)
 * Ajuster la connexion à la base de données le fichier WAR (cf. WEB-INF/config-db/jdbc.properties)
 * Relancer Tomcat
