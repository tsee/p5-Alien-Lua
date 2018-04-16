use Test2::V0;
use Test2::Tools::Spec;

use Alien::Lua;

describe 'LuaJIT tests' => sub {
    my ($jit);

    before_all 'Mock Alien::LuaJIT' => sub {
        $jit = mock 'Alien::LuaJIT',
            add_constructor => [ new => 'hash' ],
            add => [ exe => sub { 'luajit-test' } ];
    };

    case 'Can use LuaJIT' => sub {
        $Alien::Lua::CanUseLuaJIT = 1;
    };

    case 'Cannot use LuaJIT' => sub {
        $Alien::Lua::CanUseLuaJIT = 0;
    };

    describe 'Can choose to use LuaJIT' => sub {
        my ($lua, $exe);

        case 'Use LuaJIT' => sub {
            $lua = Alien::Lua->new( luajit => 1 );
            $exe = $Alien::Lua::CanUseLuaJIT ? 'luajit-test' : 'lua';
        };

        case 'Do not use LuaJIT' => sub {
            $lua = Alien::Lua->new;
            $exe = 'lua';
        };

        it 'Gets correct executable' => sub {
            is $lua->exe, $exe;
        };

        it 'Defines alien helper correctly' => sub {
            my $helper = $lua->alien_helper;

            is $helper, { lua => D() };
            is $helper->{lua}->(), $exe;
        };
    };
};

done_testing();
