use strict;
use warnings;

use Config qw(%Config);

my $lua_platform = 'linux';
use Alien::Base::ModuleBuild;
my $builder = Alien::Base::ModuleBuild->new(
  module_name => 'Alien::Lua',
  license => 'perl',
  configure_requires => {
    'Alien::Base' => '0.003',
    'Module::Build' => 0.38,
  },
  requires => {
    'perl' => '5.14.0',
    'parent' => '0',
    'Alien::Base' => 0,
  },
  dist_author => 'Steffen Mueller <smueller@cpan.org>',
  alien_name => 'lua',
  alien_repository => {
    protocol => 'local',
    location => 'inc',
    pattern  => qr/^lua-(\d[\d\.]*)\.tar\.gz$/,
  },
  alien_build_commands => [
    q#%x -I../../inc -MLuaMunger -e from_to ../../inc/luaconf.h src/luaconf.h#,
    qq#make $lua_platform INSTALL_TOP="%s"#
  ],
  alien_install_commands => [
    q#make install INSTALL_TOP="%s"#
  ],
);

$builder->create_build_script;
