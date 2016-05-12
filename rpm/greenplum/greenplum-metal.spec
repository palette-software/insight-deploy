%define serviceuser gpadmin
%define servicehome /usr/local/greenplum-db


# Disable the stupid stuff rpm distros include in the build process by default:
#   Disable any prep shell actions. replace them with simply 'true'
%define __spec_prep_post true
%define __spec_prep_pre true
#   Disable any build shell actions. replace them with simply 'true'
%define __spec_build_post true
%define __spec_build_pre true
#   Disable any install shell actions. replace them with simply 'true'
%define __spec_install_post true
%define __spec_install_pre true
#   Disable any clean shell actions. replace them with simply 'true'
%define __spec_clean_post true
%define __spec_clean_pre true
# Disable checking for unpackaged files ?
#%undefine __check_files

# Use md5 file digest method.
# The first macro is the one used in RPM v4.9.1.1
%define _binary_filedigest_algorithm 1
# This is the macro I find on OSX when Homebrew provides rpmbuild (rpm v5.4.14)
%define _build_binary_file_digest_algo 1

# Use bzip2 payload compression
%define _binary_payload w9.bzdio


Name: greenplum-metal
Version: %version
Epoch: 1
Release: %buildrelease
Summary: Greenplum Database (Bare metal)
AutoReqProv: no
# Seems specifying BuildRoot is required on older rpmbuild (like on CentOS 5)
# fpm passes '--define buildroot ...' on the commandline, so just reuse that.
#BuildRoot: %buildroot
# Add prefix, must not end with /

Prefix: /

Group: default
License: Apache2
Vendor: Pivotal / Starschema / Palette Software
URL: http://greenplum.org/
Packager: Julian <julian@palette-software.com>

#Requires: supervisor,nginx,palette-insight-certs

# Add the user for the service & setup SELinux
# ============================================

#Requires(pre): /usr/sbin/useradd, /usr/bin/getent
#Requires(postun): /usr/sbin/userdel

%pre
# Add the user and set its homee
#/usr/bin/getent passwd %{serviceuser} || /usr/sbin/useradd -r -d %{servicehome} -s /bin/bash %{serviceuser}
#/usr/bin/getent group %{serviceuser} || /usr/sbin/groupadd -r -g %{serviceuser}

# Override the SELinux flag that disallows httpd to connect to the go process
# https://stackoverflow.com/questions/23948527/13-permission-denied-while-connecting-to-upstreamnginx
#setsebool httpd_can_network_connect on -P

# Create the logfile directory for supervisord
#mkdir -p /var/log/palette-insight-server/

# Create the storage directory under /data
#mkdir -p /data/insight-server/licenses
#chown insight:insight -R /data/insight-server

# Start nginx on server start
#/sbin/chkconfig nginx on

# Start supervisord on server start
#/sbin/chkconfig supervisord on

%postun
# Dont remove the user

# TODO: we should switch back the httpd_can_network_connect flag for SELinux, IF we know that its safe to do so


# Generic RPM parts
# =================

%description
Greenplum Database is an advanced, fully featured, open source data warehouse. It provides powerful and rapid analytics on petabyte scale data volumes. Uniquely geared toward big data analytics, Greenplum Database is powered by the world’s most advanced cost-based query optimizer delivering high analytical query performance on large data volumes.

%prep
# noop

%build
# noop

%install
# noop

%clean
# noop




%files
%defattr(-,root,root,-)

# Reject config files already listed or parent directories, then prefix files
# with "/", then make sure paths with spaces are quoted. I hate rpm so much.
/usr/local/greenplum-db

%changelog

