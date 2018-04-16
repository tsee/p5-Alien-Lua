use Test2::V0;
use Test::Alien;
use Alien::Lua;

alien_ok 'Alien::Lua';

my $run = run_ok([ Alien::Lua->exe, '-v' ])->exit_is(0);
$run->success ? $run->note : $run->diag;

done_testing;
