Feature: basic features

Background:
  Given subdirectories "foo", "bar", "baz"
  And following files:
    | path         | source                                |
    | Rakefile     | examples/Rakefile.basic               |
    | foo/Rakefile | features/files/Rakefile.one_two_three |
    | bar/Rakefile | features/files/Rakefile.one_two_three |
    | baz/Rakefile | features/files/Rakefile.one_two_three |

Scenario: a simple run
  When I run "rake --trace"
  Then the command succeeds
  And following files exist:
    | path                 | content |
    | foo/one              | ONE     |
    | foo/two              | TWO     |
    | foo/three            | THREE   |
    | bar/one              | ONE     |
    | bar/two              | TWO     |
    | bar/three            | THREE   |
    | baz/one              | ONE     |
    | baz/two              | TWO     |
    | baz/three            | THREE   |
    | _published/foo/one   | ONE     |
    | _published/foo/two   | TWO     |
    | _published/foo/three | THREE   |
    | _published/bar/one   | ONE     |
    | _published/bar/two   | TWO     |
    | _published/bar/three | THREE   |
    | _published/baz/one   | ONE     |
    | _published/baz/two   | TWO     |
    | _published/baz/three | THREE   |

Scenario: one of the directories are published
  Given subdirectory "_published"
  And following files:
    | path                 | content |
    | _published/baz/one   | JEDEN   |
    | _published/baz/two   | DWA     |
    | _published/baz/three | TRZY    |
  When I run "rake"
  Then the command succeeds
  And following files exist:
    | path                 | content |
    | foo/one              | ONE     |
    | foo/two              | TWO     |
    | foo/three            | THREE   |
    | bar/one              | ONE     |
    | bar/two              | TWO     |
    | bar/three            | THREE   |
    | _published/foo/one   | ONE     |
    | _published/foo/two   | TWO     |
    | _published/foo/three | THREE   |
    | _published/bar/one   | ONE     |
    | _published/bar/two   | TWO     |
    | _published/bar/three | THREE   |
    | _published/baz/one   | JEDEN   |
    | _published/baz/two   | DWA     |
    | _published/baz/three | TRZY    |
  And following files do not exist:
    | path      |
    | baz/one   |
    | baz/two   |
    | baz/three |

