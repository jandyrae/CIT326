-- docker run --name kiger_final -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=cit326Password$' -e 'MSSQL_AGENT_ENABLED=True' -p 49433:1433 -d jandyrae/cit326-final:pokemon_backup


docker run --hostname=4818819e5ae1 --user=mssql --mac-address=02:42:ac:11:00:02 --env=ACCEPT_EULA=Y --env=SA_PASSWORD=cit326Password$ --env=MSSQL_AGENT_ENABLED=True --env=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin -p 49433:1433 --restart=no --label='com.microsoft.product=Microsoft SQL Server' --label='com.microsoft.version=15.0.4298.1' --label='vendor=Microsoft' --runtime=runc -d mcr.microsoft.com/mssql/server:2019-latest

 --docker commit ecstatic_germain jandyrae/cit326-final:pokemon_backup