FROM centos/php-73-centos7

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications for ITPS purposes" \
    DESCRIPTION="PHP $PHP_VERSION available as container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

USER 0

# Install MSSQL
RUN INSTALL_PREREQUIS_MSSQL="gcc-c++ gcc rh-php73-php-devel rh-php73-php-pear yum-utils" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PREREQUIS_MSSQL --nogpgcheck

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo && \
    yum -y remove unixODBC-utf16 unixODBC-utf16-devel && \
    yum -y install unixODBC-devel && \
    ACCEPT_EULA=Y yum -y install msodbcsql17 && \
    ACCEPT_EULA=Y yum -y install mssql-tools && \
    rpm -V msodbcsql17 mssql-tools unixODBC-devel && \
    pecl install sqlsrv && \
    pecl install pdo_sqlsrv && \
    echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini && \
    echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini

USER 1001

