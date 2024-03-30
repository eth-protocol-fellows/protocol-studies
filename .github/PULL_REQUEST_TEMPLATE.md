# Checklist

- [ ] Review changes to ensure there are no typos.

<!-- 
ℹ️ Checking for typos locally
1. Install [aspell](https://www.gnu.org/software/aspell/) for your platform.
2. Navigate to the project root and run:
```
 for f in **/*.md ; do echo $f ; aspell --lang=en_US --mode=markdown --home-dir=. --personal=wordlist.txt --ignore-case=true list  < $f | sort | uniq -c ; done
```

ℹ️ Fixing typos
1. Fix typos: Open the relevant files and fix any identified typos.
2. Update wordlist: If a flagged word is actually a project-specific term add it to `wordlist.txt` in the project root.
   Each word should be listed on a separate line and must not have any spaces before or after it.
-->