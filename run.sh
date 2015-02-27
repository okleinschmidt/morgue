#!/bin/sh

# startup script to create the configuration from the environment

# default values

[ -n "${MYSQL_DATABASE}" ] || MYSQL_DATABASE="morgue"
[ -n "${MYSQL_HOST}" ]     || MYSQL_HOST="localhost"
[ -n "${MYSQL_PORT}" ]     || MYSQL_PORT="3306"
[ -n "${MYSQL_USER}" ]     || MYSQL_USER="morgue"
[ -n "${MYSQL_PASSWORD}" ] || MYSQL_PASSWORD="morgue"
[ -n "${PORT}" ]           || PORT="8080"

cat > "/tmp/morgue.json" <<EOF
{
    "environment": "bazooka",
    "timezone": "UTC",
    "time_format": "H:i",
    "date_format": "Y-m-d",


    "database":
    {  "mysqlhost": "${MYSQL_HOST}",
        "mysqlport": ${MYSQL_PORT},
        "database": "${MYSQL_DATABASE}",
        "username": "${MYSQL_USER}",
        "password": "${MYSQL_PASSWORD}"
    },


    "severity" :
    { "tooltip_title" : "Severity Levels",
      "levels" : [
            "Any user-impacting service disruption of a feature that is on the Key Features list",
            "Any user-impacting service disruption of a feature that is not on the Key Features list",
            "Any service disruption that does not impact users"
        ]
    },
    "edit_page_features" : [
      "status_time",
      "calendar",
      "summary",
      "images",
      "links",
      "tags",
      "history"
    ],

    "feature": [

    {   "name": "status_time",
        "enabled": "on"
    },

    {   "name": "contact",
        "enabled": "off",
        "lookup_url" : null
    },

    {   "name": "calendar",
        "enabled": "on"
    },

    {   "name": "summary",
        "enabled": "on"
    },

    {   "name": "images",
        "enabled": "on"
    },

    {   "name": "irc",
        "enabled": "off",
        "channels": ["#ops"]
    },

    {   "name": "jira",
        "enabled": "off",
        "baseurl": "https://jira.foo.com",
        "username": "jira_morgue",
        "password": "jira_morgue_password",
        "additional_fields" : {
        }
    },

    {   "name": "links",
        "enabled": "on"
    },

    {   "name": "tags",
        "enabled": "on"
    },

    {   "name": "history",
        "enabled": "off"
    }

    ]
}
EOF

MORGUE_ENVIRONMENT=bazooka
export MORGUE_ENVIRONMENT

exec ./mk/vendor/bin/php -n -d include_path=".:./features" -S "0.0.0.0:${PORT}"
