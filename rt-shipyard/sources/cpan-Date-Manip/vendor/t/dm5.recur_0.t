#!/usr/bin/perl -w

use Test::Inter;
$t = new Test::Inter 'DM5 :: ParseRecur';
$testdir = '';
$testdir = $t->testdir();

BEGIN {
   $Date::Manip::Backend = 'DM5';
}

use Date::Manip;

Date_Init("TZ=EST");
Date_Init(qw( PersonalCnf=Manip5.cnf PathSep=! PersonalCnfPath=./t!. IgnoreGlobalCnf=1 ));

$tests ="

1*1:1:1:0:0:0*EASTER
'Jan 1 1997'
'Jan 1 1997'
'Jan 1 2000'
   =>
   1997033000:00:00
   1998041200:00:00
   1999040400:00:00

*1997-1999:1:1:1:0:0:0*EASTER
   =>
   1997033000:00:00
   1998041200:00:00
   1999040400:00:00

*1999:1:1,2:6:0:0:0*CWD
   =>
   1999010400:00:00
   1999010800:00:00

*1999:1:1,2:6:0:0:0*CWP
   =>
   1998123100:00:00
   1999010800:00:00

*1999:1:1,2:6:0:0:0*CWN
   =>
   1999010400:00:00
   1999010800:00:00

*1999:1-4:2:0:12:00:00*PD1,BD2,FW2
   =>
   1999010512:00:00
   1999020212:00:00
   1999030212:00:00
   1999040612:00:00

*1999:1-4:2:0:12:00:00*PD1,BD2
   =>
   1999010212:00:00
   1999013012:00:00
   1999022712:00:00
   1999040312:00:00

*1999:1-4:2:0:12:00:00*PD1
   =>
   1999010412:00:00
   1999020112:00:00
   1999030112:00:00
   1999040512:00:00

*1999:1-4:2:0:12:00:00*PT1
   =>
   1999011112:00:00
   1999020812:00:00
   1999030812:00:00
   1999041212:00:00

*1999:1-2:2:0:12:00:00*PD7
   =>
   1999011012:00:00
   1999020712:00:00

*1999:1-2:2:0:12:00:00
   =>
   1999011112:00:00
   1999020812:00:00

*1999:1-4:2:0:12:00:00*MW3
   =>
   1999011112:00:00
   1999020812:00:00
   1999030812:00:00
   1999041212:00:00

0*1-4:2:0:12:00:00*MW3
'Jan 1 1999'
'Jan 1 1999'
'Jan 1 2000'
   =>
   1999011112:00:00
   1999020812:00:00
   1999030812:00:00
   1999041212:00:00

0:1*2:0:12:00:00*MW3
'Jan 1 1999'
'Jan 1 1999'
'May 1 1999'
   =>
   1999011112:00:00
   1999020812:00:00
   1999030812:00:00
   1999041212:00:00

0:0:0:0:12:0:0
'Jan 16 1998 at 12:00'
'Jan 15 1998 at 00:00'
'Jan 20 1998 at 00:00'
   =>
   1998011500:00:00
   1998011512:00:00
   1998011600:00:00
   1998011612:00:00
   1998011700:00:00
   1998011712:00:00
   1998011800:00:00
   1998011812:00:00
   1998011900:00:00
   1998011912:00:00

0:0:0:1*12,14:0,30:0
'Jan 16 1998 at 12:00'
'Jan 15 1998 at 00:00'
'Jan 20 1998 at 00:00'
   =>
   1998011512:00:00
   1998011512:30:00
   1998011514:00:00
   1998011514:30:00
   1998011612:00:00
   1998011612:30:00
   1998011614:00:00
   1998011614:30:00
   1998011712:00:00
   1998011712:30:00
   1998011714:00:00
   1998011714:30:00
   1998011812:00:00
   1998011812:30:00
   1998011814:00:00
   1998011814:30:00
   1998011912:00:00
   1998011912:30:00
   1998011914:00:00
   1998011914:30:00

0:0:0:1:6*0,30:0
'Jan 16 1998 at 12:00'
'Jan 15 1998 at 00:00'
'Jan 20 1998 at 00:00'
   =>
   1998011506:00:00
   1998011506:30:00
   1998011612:00:00
   1998011612:30:00
   1998011718:00:00
   1998011718:30:00
   1998011900:00:00
   1998011900:30:00

2:0:0*045:0:0:0
'Jan 1 1998'
'Jan 1 1980'
'Jan 1 1990'
   =>
   1980021400:00:00
   1982021400:00:00
   1984021400:00:00
   1986021400:00:00
   1988021400:00:00

2:0:0*045-047:0:0:0
'Jan 1 1998'
'Jan 1 1980'
'Jan 1 1990'
   =>
   1980021400:00:00
   1980021500:00:00
   1980021600:00:00
   1982021400:00:00
   1982021500:00:00
   1982021600:00:00
   1984021400:00:00
   1984021500:00:00
   1984021600:00:00
   1986021400:00:00
   1986021500:00:00
   1986021600:00:00
   1988021400:00:00
   1988021500:00:00
   1988021600:00:00

2:1:0*0:0:0:0
'Jan 1 1985'
'Jan 1 1980'
'Jan 1 1990'
   =>
   1980110100:00:00
   1982120100:00:00
   1985010100:00:00
   1987020100:00:00
   1989030100:00:00

0:0:2*2:0:0:0
'Jan 16 1998'
'Jan  1 1998'
'Feb 28 1998'
   =>
   1998011300:00:00
   1998012700:00:00
   1998021000:00:00
   1998022400:00:00

0:0:2*2,4:0:0:0
'Jan 16 1998'
'Jan  1 1998'
'Feb 28 1998'
   =>
   1998010100:00:00
   1998011300:00:00
   1998011500:00:00
   1998012700:00:00
   1998012900:00:00
   1998021000:00:00
   1998021200:00:00
   1998022400:00:00
   1998022600:00:00

0:1:0*2,31:0:0:0
'Jan 1 1998'
'Jan 1 1998'
'Jul 1 1998'
   =>
   1998010200:00:00
   1998013100:00:00
   1998020200:00:00
   1998030200:00:00
   1998033100:00:00
   1998040200:00:00
   1998050200:00:00
   1998053100:00:00
   1998060200:00:00

0:1:0*-2,-31:0:0:0
'Jan 1 1998'
'Jan 1 1998'
'Jul 1 1998'
   =>
   1998010100:00:00
   1998013000:00:00
   1998022700:00:00
   1998030100:00:00
   1998033000:00:00
   1998042900:00:00
   1998050100:00:00
   1998053000:00:00
   1998062900:00:00

0:1*2,-1:0:0:0:0
'Jan  1 1998'
'Jan  1 1998'
'Mar 31 1998'
   =>
   1998011200:00:00
   1998012600:00:00
   1998020900:00:00
   1998022300:00:00
   1998030900:00:00
   1998033000:00:00

0:1*2,-2:2:0:0:0
'Jan 1 1998'
'Jan 1 1998'
'Jul 1 1998'
   =>
   1998011300:00:00
   1998012000:00:00
   1998021000:00:00
   1998021700:00:00
   1998031000:00:00
   1998032400:00:00
   1998041400:00:00
   1998042100:00:00
   1998051200:00:00
   1998051900:00:00
   1998060900:00:00
   1998062300:00:00

2:0*10:0:0:0:0
'Jan 1 1985'
'Jan 1 1980'
'Jan 1 1990'
   =>
   1981030900:00:00
   1983030700:00:00
   1985031100:00:00
   1987030900:00:00
   1989030600:00:00

2:0*10:2:0:0:0
'Jan 1 1985'
'Jan 1 1980'
'Jan 1 1990'
   =>
   1981031000:00:00
   1983030800:00:00
   1985030500:00:00
   1987031000:00:00
   1989030700:00:00

2*3:0:2,30:0:0:0
'Jan 1 1985'
'Jan 1 1980'
'Jan 1 1990'
   =>
   1981030200:00:00
   1981033000:00:00
   1983030200:00:00
   1983033000:00:00
   1985030200:00:00
   1985033000:00:00
   1987030200:00:00
   1987033000:00:00
   1989030200:00:00
   1989033000:00:00

2*3:0:0:0:0:0
'Jan 1 1985'
'Jan 1 1980'
'Jan 1 1990'
   =>
   1981030100:00:00
   1983030100:00:00
   1985030100:00:00
   1987030100:00:00
   1989030100:00:00

3*2,5:2,-2:0:0:0:0
'Jan 1 1985'
'Jan 1 1980'
'Jan 1 1986'
   =>
   1982020800:00:00
   1982021500:00:00
   1982051000:00:00
   1982052400:00:00
   1985021100:00:00
   1985021800:00:00
   1985051300:00:00
   1985052000:00:00

3*5,2:2,-2:0:0:0:0
'Jan 1 1985'
'Jan 1 1980'
'Jan 1 1986'
   =>
   1982020800:00:00
   1982021500:00:00
   1982051000:00:00
   1982052400:00:00
   1985021100:00:00
   1985021800:00:00
   1985051300:00:00
   1985052000:00:00

3*2,5:2:2:0:0:0
'Jan 1 1985'
'Jan 1 1980'
'Jan 1 1990'
   =>
   1982020900:00:00
   1982051100:00:00
   1985021200:00:00
   1985051400:00:00
   1988020900:00:00
   1988051000:00:00

1*2:2:0:0:0:0
''
'Jan 1 1980'
'Dec 1 1982'
   =>
   1980021100:00:00
   1981020900:00:00
   1982020800:00:00

1*2:2:2:0:0:0
''
'Jan 1 1980'
'Dec 1 1982'
   =>
   1980021200:00:00
   1981021000:00:00
   1982020900:00:00

*2000:2:1:1:0:0:0
   =>
   2000020700:00:00

*2000:2:1:-1:0:0:0
   =>
   2000020600:00:00

*2000:2:1:0:0:0:0
   =>
   2000020700:00:00

*2000:2:-1:1:0:0:0
   =>
   2000022800:00:00

*2000:2:-1:-1:0:0:0
   =>
   2000022700:00:00

*2000:2:-1:0:0:0:0
   =>
   2000022800:00:00

*2000:0:0:0:0:0:0
   =>
   2000010100:00:00

*2000:0:0:61:0:0:0
   =>
   2000030100:00:00

*2000:0:0:-1:0:0:0
   =>
   2000123100:00:00

*2000:2:0:2:0:0:0
   =>
   2000020200:00:00

*2000:2:0:-2:0:0:0
   =>
   2000022800:00:00

*2000:0:2:2:0:0:0
   =>
   2000011100:00:00

*2000:0:2:-2:0:0:0
   =>
   2000010800:00:00

*2000:0:-2:2:0:0:0
   =>
   2000121900:00:00

*2000:0:-2:-2:0:0:0
   =>
   2000122300:00:00

*2000:0:2:0:0:0:0
   =>
   2000011000:00:00

*2000:0:-2:0:0:0:0
   =>
   2000121800:00:00

*1990,1992:0:0:45:0:0:0
   =>
   1990021400:00:00
   1992021400:00:00

*1990,1992:0:0:0:0:0:0
   =>
   1990010100:00:00
   1992010100:00:00

*1990,1992:5:0:0:0:0:0
   =>
   1990050100:00:00
   1992050100:00:00

*1990,1992:5:0:12:0:0:0
   =>
   1990051200:00:00
   1992051200:00:00

*1998:0:12,14:0:0:0:0
   =>
   1998032300:00:00
   1998040600:00:00

*1998:0:12,14:2:0:0:0
   =>
   1998032400:00:00
   1998040700:00:00

*1998:2:2,-2:0:0:0:0
   =>
   1998020900:00:00
   1998021600:00:00

*1998:2:2,-2:2:0:0:0
   =>
   1998021000:00:00
   1998021700:00:00

*1998:2:2,-2:-6:0:0:0
   =>
   1998021000:00:00
   1998021700:00:00

*1998:2:2,-2:2:0:0:0
1998021000:00:00
1998021000:00:00
1998021200:00:00
   =>
   1998021000:00:00

1*2:0:-1:0:0:0
''
2000-01-01
2005-12-31
   =>
   2000022900:00:00
   2001022800:00:00
   2002022800:00:00
   2003022800:00:00
   2004022900:00:00
   2005022800:00:00

1:0*2:0:0:0:0
''
2000-01-01
2000-12-31
   =>
   2000011000:00:00

1:0*-2:0:0:0:0
''
2000-01-01
2000-12-31
   =>
   2000121800:00:00

1:0*2:1:0:0:0
''
2000-01-01
2000-12-31
   =>
   2000011000:00:00

1:0*-2:1:0:0:0
''
2000-01-01
2000-12-31
   =>
   2000121800:00:00

1:0*2:-7:0:0:0
''
2000-01-01
2000-12-31
   =>
   2000011000:00:00

1:0*-2:-7:0:0:0
''
2000-01-01
2000-12-31
   =>
   2000121800:00:00

1:1*2:0:0:0:0
'Jan 10 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000011000:00:00
   2001021200:00:00
   2002031100:00:00

1:1*-2:0:0:0:0
'Jan 10 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000012400:00:00
   2001021900:00:00
   2002031800:00:00

1:1*2:1:0:0:0
'Jan 10 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000011000:00:00
   2001021200:00:00
   2002031100:00:00

1:1*-2:1:0:0:0
'Jan 10 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000012400:00:00
   2001021900:00:00
   2002031800:00:00

1:1*2:-7:0:0:0
'Jan 10 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000011000:00:00
   2001021200:00:00
   2002031100:00:00

1:1*-2:-7:0:0:0
'Jan 10 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000012400:00:00
   2001021900:00:00
   2002031800:00:00

1:1:1*0:0:0:0
'Jan  4 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000010400:00:00
   2001021100:00:00
   2002031800:00:00

1:0:0*15:0:0:0
''
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000011500:00:00
   2001011500:00:00
   2002011500:00:00

1:0:0*-10:0:0:0
''
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000122200:00:00
   2001122200:00:00
   2002122200:00:00

1:1:1*2:0:0:0
'Jan  4 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000010400:00:00
   2001021100:00:00
   2002031800:00:00

1:1:1*-6:0:0:0
'Jan  4 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000010400:00:00
   2001021100:00:00
   2002031800:00:00

1:1:0*10:0:0:0
'Jan  4 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000011000:00:00
   2001021000:00:00
   2002031000:00:00

*2000-2009:0:0:366:0:0:0
   =>
   2000123100:00:00
   2004123100:00:00
   2008123100:00:00

*2000:1-5:0:31:0:0:0
   =>
   2000013100:00:00
   2000033100:00:00
   2000053100:00:00

*2000-2009:0:53:1:0:0:0
   =>
   2001123100:00:00
   2007123100:00:00

*2000-2009:0:-53:1:0:0:0
   =>
   2001010100:00:00
   2007010100:00:00

1*1-4:0:31:0:0:0
''
'Jan  1 2000'
'Dec 31 2000'
   =>
   2000013100:00:00
   2000033100:00:00

1*1-4:0:-31:0:0:0
''
'Jan  1 2000'
'Dec 31 2000'
   =>
   2000010100:00:00
   2000030100:00:00

1:1:0*-10:0:0:0
'Jan  4 2000'
'Jan  1 2000'
'Dec 31 2002'
   =>
   2000012200:00:00
   2001021900:00:00
   2002032200:00:00

*2000:1-5:5:-1:0:0:0
   =>
   2000013000:00:00
   2000043000:00:00

*2000:1-5:-5:-1:0:0:0
   =>
   2000010200:00:00
   2000040200:00:00

*2000:1-5:5:0:0:0:0
   =>
   2000013100:00:00
   2000052900:00:00

*2000:1-5:-5:0:0:0:0
   =>
   2000010300:00:00
   2000050100:00:00

1*1-5:5:-1:0:0:0
''
'Jan 1 2000'
'Dec 1 2000'
   =>
   2000013000:00:00
   2000043000:00:00

1*1-5:-5:-1:0:0:0
''
'Jan 1 2000'
'Dec 1 2000'
   =>
   2000010200:00:00
   2000040200:00:00

1*1-5:5:0:0:0:0
''
'Jan 1 2000'
'Dec 1 2000'
   =>
   2000013100:00:00
   2000052900:00:00

1*1-5:-5:0:0:0:0
''
'Jan 1 2000'
'Dec 1 2000'
   =>
   2000010300:00:00
   2000050100:00:00

1:0*53:1:0:0:0
''
'Jan 1 2000'
'Jan 1 2010'
   =>
   2001123100:00:00
   2007123100:00:00

1:0*-53:1:0:0:0
''
'Jan 1 2000'
'Jan 1 2010'
   =>
   2001010100:00:00
   2007010100:00:00

1:0:0*366:0:0:0
''
'Jan 1 2000'
'Jan 1 2010'
   =>
   2000123100:00:00
   2004123100:00:00
   2008123100:00:00

1:0:0*-366:0:0:0
''
'Jan 1 2000'
'Jan 1 2010'
   =>
   2000010100:00:00
   2004010100:00:00
   2008010100:00:00

0:1*1:1:12:0:0
''
'Sep 1 2007'
'Nov 20 2007'
   =>
   2007090312:00:00
   2007100112:00:00
   2007110512:00:00

0:0:1*1:12:30:0
''
'Sep 1 2007'
'Sep 30 2007'
   =>
   2007090312:30:00
   2007091012:30:00
   2007091712:30:00
   2007092412:30:00

0:1:0*1:12:0:0
''
'Sep 1 2007'
'Dec 15 2007'
   =>
   2007090112:00:00
   2007100112:00:00
   2007110112:00:00
   2007120112:00:00

0:0:0:0:1*30:0
''
'Jan 1 1990 12:12'
'Jan 2 1990 01:32'
   =>
   1990010112:30:00
   1990010113:30:00
   1990010114:30:00
   1990010115:30:00
   1990010116:30:00
   1990010117:30:00
   1990010118:30:00
   1990010119:30:00
   1990010120:30:00
   1990010121:30:00
   1990010122:30:00
   1990010123:30:00
   1990010200:30:00
   1990010201:30:00

";

$t->tests(func  => \&ParseRecur,
          tests => $tests);
$t->done_testing();

#Local Variables:
#mode: cperl
#indent-tabs-mode: nil
#cperl-indent-level: 3
#cperl-continued-statement-offset: 2
#cperl-continued-brace-offset: 0
#cperl-brace-offset: 0
#cperl-brace-imaginary-offset: 0
#cperl-label-offset: 0
#End:
