# Usage: ./cg84-migration.sh catalogue catalogue

function showUsage
{
  echo -e "\nThis script is used to migrate CG84 from 2.4.3 to 2.11.0"
  echo -e "Usage: ./`basename $0 $1` username database server port password"
}

if [ $# -lt 4 ]
then
  showUsage
  exit
fi

if [ "$1" = "-h" ]
then
        showUsage
        exit
fi

# TODO : default to 127.0.0.1 and port 5432
export PGPASSWORD=$5
psql -U $1 -h $3 -p $4 -f run.sql $2 -L log-$2-query.log -o log-$2.log


