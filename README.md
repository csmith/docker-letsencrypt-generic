# Let's Encrypt Generic DNS Service

This container uses [dehydrated](https://github.com/lukas2511/dehydrated)
to automatically obtain SSL certs from [Let's Encrypt](https://letsencrypt.org/).

You need to provide a hook that will perform DNS updates on your domains.
If you use a cloud DNS provider, you're probably better off using
[letsencrypt-lexicon](https://github.com/csmith/letsencrypt-lexicon).

Multiple domains, as well as SANs, are supported. Certificates will be
renewed automatically, and obtained automatically as soon as new domains
are added.

## Usage

### Defining domains

The container defines one volume at `/letsencrypt`, and expects there to be
a list of domains in `/letsencrypt/domains.txt`. Certificates are output to
`/letsencrypt/certs/{domain}`.

domains.txt should contain one line per certificate. If you want alternate
names on the cert, these should be listed after the primary domain. e.g.

```
example.com www.example.com
admin.example.com
```

This will request two certificates: one for example.com with a SAN of
www.example.com, and a separate one for admin.example.com.

The container uses inotify to monitor the domains.txt file for changes,
so you can update it while the container is running and changes will be
automatically applied.

### Hook 

To verify that you own the domain, a TXT record needs to be automatically
created for it. For this container, you must provide a hook that can do
the update. See the documentation for
[dehydrated](https://github.com/lukas2511/dehydrated) for details
on the arguments it takes.

The container expects an executable at `/dns/hook`, so you'll need to
mount the `/dns` folder or `/dns/hook` file when running the container.

### Other configuration

For testing purposes, you can set the `STAGING` environment variable to
a non-empty value. This will use the Let's Encrypt staging server, which
has much more relaxed limits.

You should pass in a contact e-mail address by setting the `EMAIL` env var.
This is passed on to Let's Encrypt, and may be used for important service
announcements.

### Running

Here's a full worked example:

```bash
# The directory we'll use to store the domain list and certificates.
# You could use a docker volume instead.
mkdir /tmp/letsencrypt
echo "domain.com www.domain.com" > /tmp/letsencrypt/domains.txt

docker run -d --restart=always \
  -e "EMAIL=admin@domain.com" \
  -e "STAGING=true" \
  -v /tmp/letsencrypt:/letsencrypt \
  -v /home/user/my-dns-script:/dns \
  csmith/letsencrypt-generic:latest
```

