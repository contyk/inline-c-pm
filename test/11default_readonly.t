# Checks that Inline's bind function still works when $_ is readonly. (Bug #55607)
# Thanks Marty O'Brien.

use File::Spec;
use strict;
use diagnostics;
use File::Basename;
use lib dirname(__FILE__);
use TestInlineSetup;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

print "1..1\n";

# The following construct not allowed under
# strictures (refs). Hence strictures for
# refs have been turned off.
{
no strict ('refs');
  for ('function') {
    $_->();
  }
}

if(foo(15) == 30) {print "ok 1\n"}
else {
  warn "Expected 30, got ", foo(15), "\n";
  print "not ok 1\n";
}

sub function {
  use Inline C => Config =>
    USING => 'ParseRegExp';

    Inline->bind(C => <<'__CODE__');
    int foo(SV * x) {
      return (int)SvIV(x) * 2;
    }
__CODE__
}
