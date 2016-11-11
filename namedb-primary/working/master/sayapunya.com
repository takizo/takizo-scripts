$TTL 300
$ORIGIN sayapunya.com.

@       IN SOA  ns1.takizo.com.    support.takizo.com. (
        2005032700        ; Serial
        300               ; Refresh
        360               ; Retry
        300               ; Expire
        300             ) ; Minimum

sayapunya.com.    300     IN A            202.71.102.186
sayapunya.com.    300     IN MX           100 mx.sayapunya.com.
sayapunya.com.    300     IN NS           ns1.takizo.com.
sayapunya.com.    300     IN NS           ns2.takizo.com.

pop             300     IN CNAME        mx.sayapunya.com.
smtp            300     IN CNAME        mx.sayapunya.com.
www             300     IN CNAME	mx.sayapunya.com.
webmail         300     IN CNAME        mx.sayapunya.com.
imap            300     IN CNAME        mx.sayapunya.com.
mx              300     IN A            202.71.102.186
lemang              300     IN A            202.71.102.186

