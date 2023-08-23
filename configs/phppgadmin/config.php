<?php
$conf['servers'][1]['desc'] = 'local';
$conf['servers'][1]['host'] = '127.0.0.1';
$conf['servers'][1]['port'] = 5432;
$conf['servers'][1]['sslmode'] = 'allow';
$conf['servers'][1]['defaultdb'] = 'postgres';
$conf['servers'][1]['pg_dump_path'] = '/usr/bin/pg_dump';
$conf['servers'][1]['pg_dumpall_path'] = '/usr/bin/pg_dumpall';

// $conf['servers'][0]['desc'] = '';
// $conf['servers'][0]['host'] = '';
// $conf['servers'][0]['port'] = 5432;
// $conf['servers'][0]['sslmode'] = 'allow';
// $conf['servers'][0]['defaultdb'] = 'postgres';
// $conf['servers'][0]['pg_dump_path'] = '/usr/bin/pg_dump';
// $conf['servers'][0]['pg_dumpall_path'] = '/usr/bin/pg_dumpall';

//$conf['srv_groups'][0]['desc'] = 'group one';
//$conf['srv_groups'][0]['servers'] = '0,1,2';
//$conf['srv_groups'][1]['desc'] = 'group two';
//$conf['srv_groups'][1]['servers'] = '3,1';
//$conf['srv_groups'][2]['desc'] = 'group three';
//$conf['srv_groups'][2]['servers'] = '4';
//$conf['srv_groups'][2]['parents'] = '0,1';

//$conf['servers'][0]['theme']['default'] = 'default';
//$conf['servers'][0]['theme']['user']['specific_user'] = 'default';
//$conf['servers'][0]['theme']['db']['specific_db'] = 'default';
$conf['default_lang'] = 'auto';
$conf['autocomplete'] = 'default on';
$conf['extra_login_security'] = false;
$conf['owned_only'] = true;
$conf['show_comments'] = true;
$conf['show_advanced'] = false;
$conf['show_system'] = false;
$conf['min_password_length'] = 8;
$conf['left_width'] = 200;
$conf['theme'] = 'default';
$conf['show_oids'] = false;
$conf['max_rows'] = 30;
$conf['max_chars'] = 50;
$conf['use_xhtml_strict'] = false;
$conf['help_base'] = 'http://www.postgresql.org/docs/%s/interactive/';
$conf['ajax_refresh'] = 3;

$conf['plugins'] = array();

/*****************************************
 * Don't modify anything below this line *
 *****************************************/
$conf['version'] = 19;
?>
