use lib '.';
use inc::Module::Install;

RTx     'RT-Extension-Kpi';
license 'gpl_2';
repository 'https://github.com/bestpractical/rt-extension-kpi';

requires_rt '4.4.0';
rt_too_new '5.2.0';

sign;
WriteAll;
