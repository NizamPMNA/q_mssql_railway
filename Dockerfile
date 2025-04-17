# Use the Microsoft SQL Server 2019 image as a base image
FROM mcr.microsoft.com/mssql/server:2019-latest

# Set environment variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=997755
ENV MSSQL_PID=Express

# Install SQL Server Command Line Tools (sqlcmd and bcp)
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

# Expose the port SQL Server runs on
EXPOSE 1433

# Copy your local database script into the container
COPY ./qscript.sql /qscript.sql

# Command to run SQL Server and execute the script
CMD /bin/bash -c "/opt/mssql/bin/sqlservr & /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P '997755' -d master -i /qscript.sql && tail -f /dev/null"
