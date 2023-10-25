## 0.1.2

- chore: bump version to 0.1.2
- fix: unhandled exception for run command
- fix: unhandled exception when packages is [] and running loki app
- fix: unhandled exception when given packages list has directories that doesn't exit

## 0.1.1

- chore: write test for run command and run subcommand
- chore: write tests for app and app subcommand. add process manager for handling test cases
- chore: Write tests for clean,fetch,list,validate,version commands. modify tests for projects_filter. optimize project creator for testing. and handle te
- chore: write tests for app and app subcommand. add process manager for handling test cases
- chore: Write tests for clean,fetch,list,validate,version commands. modify tests for projects_filter. optimize project creator for testing. and handle te
  sting concurrently by using flutter lock runner and different project dirs
- chore: Write tests for cache
- chore: Add few tests and make some code testable
- chore: remove documentation from pubspec
- fix: updated run command had issues with displaying info

## 0.1.0

- chore: update README.md and loki.yaml
- feat: scripts can execute 'loki run' with a shorthand 'lkr'
- feat: sequential and recursive scripts with loki. fixed description issue with run command.

## 0.0.2

- chore: add MIT LICENSE
- chore: update CHANGELOG.md
- chore: After dart analyze and format
- chore: update changelog.md
- chore: update for release to pub.dev

## 0.0.1

- chore: Add documentation and update README
- chore: add example
- docs: contribute.md
- docs: Write install md
- docs: Write readme
- refactor: Proper use of CommandRunner for  command
- chore: use green text instead of greenbright
- feat: Add emoji, change scriptconfig to accept stdin instead of flutter_run as key, and proper cli console on clean and fetch
- feat: on loki command, don't fetch but show usage. Add more description in loki top level command/help
- chore: write proper help texts in app subcommand
- chore: add author tag in version command
- chore: Display output change
- feat: add environment option and verbose option to app <appname> command
- feat: remove aliases from validate command
- feat: remove alias from version command
- fix: While finding packages do not follow links
- feat: Add app command Author: Dorji Gyeltshen(dg.dorjigyeltshen@gmail.com)
- refactor: use command runner instead of custom runner
- initial commit