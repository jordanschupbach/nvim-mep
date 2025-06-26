
local bannertext = {
  '',
  '',
  '',
  '              :Wu                             uueeeou        .uodWWb            ',
  '       uu.    \'$"N.   s.                   .o$$$$$$$$$u.uuuo@$$$**#"           ',
  '      4$F#Nu.  $ ^*u  \'$                  s$$$$$*$$N$$$$$*#""7$uuedN$!!        ',
  '       #$L `"*e$b  "N  #c                 ?$$$$E  "#BB$P` .o$$*#""""*Nbe        ',
  ' .uuuuu."$o    """   #c #c\'$               #$$$$$N   `"` d$$"          `N.     ',
  ' ```````"^""    .     "  %\'$ ..             "t$$$$ou... !**"            "$     ',
  '    ....   -m**+X?!+.      *$*".             3$P*""""**                  ?&     ',
  ':ed*$$"""        `          .e*#             9E...... `=.                <$k    ',
  '  ..$"        .um***o.       #*mx         \'"%$$$$$$$$$No"u      <$&  d$>  #E   ',
  ' """$     m*"""`     `   .   =mu.        -x..." " "<"<#R "`     4$F  $$"  .6    ',
  '    $                   -*P   u.`         uU$$          "       \'#\\uudNood$$* ',
  '    $       o   e           .$#"        **(                     .o$$$$$$$$$$Ru  ',
  '    $       $k  $k        .u$b.            "$R           X<.:   ?$$$$$$$R$$$$$  ',
  '    $>      @P* ""        ""`^#o          i).-          ""$$k    $$$$$$$$$$$$   ',
  "    @&      $                  $           .uudbr         '$$NL  '\"$B$$$$$R$F  ",
  '    *$:     "moe$         .  .$"           ` x"           \'$$$$$Nbu.`"?7D@#`   ',
  '     $!       ^"         u$****             \'*@#")..x      #$$B$F `` """`      ',
  '     $k          ...    @P"                     """"  xe    #B$F .              ',
  '      $o.    ""*$$$$  .$"                             \'#$u.    .d#             ',
  '       "$e..         .$`                                "*RNeed*"               ',
  'MiseEnPlace',
  '',
  '',
  '',
  '',
}


require('dashboard').setup {
  theme = 'doom',
  config = {
    header = bannertext,
    center = {
      {
        icon = ' ',
        desc = 'Projects',
        key = 'p',
        -- keymap = 'SPC f d',
        key_format = ' %s',
        action = 'Telescope project',
      },
    },
    footer = {}, --your footer
  },
}
