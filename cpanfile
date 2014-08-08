requires 'perl', 'v5.10.1';

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Test::Exception', '0.32';
};

requires 'Module::Build', '0.3601';
requires 'Catmandu';
requires 'Moo';
requires 'Furl', '0.41';
requires 'Catmandu::XML', '0.14';
