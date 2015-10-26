
Test av migrering av Ediffah EAD till EAD 2002 XML
--------------------------------------------------

Batchkonvertera med t.ex.

```bash
$ for i in ./testdata/*.ead ; do xsltproc v1to02.xsl "$i" > "$i.xml" ; done
```
