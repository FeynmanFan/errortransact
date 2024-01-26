# Use the official SQL Server image as the base image
FROM mcr.microsoft.com/mssql/server:2022-latest

# Set environment variables for SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=yourStrong(!)Password

# Create a directory to store SQL scripts
WORKDIR ./

# Copy the SQL script to the container
COPY ./db.sql .

# Run SQL Server and execute the SQL script
CMD /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i db.sql

# Expose the default SQL Server port
EXPOSE 1433