%{
#include "posfixo.tab.h"
%}

%%

[\n\t ]  

\+    { return MAIS; }
\-    { return MENOS; }
\*    { return ASTERISCO;  }
\/    { return DIV;  }
b     { return BOOL;   }
a     { return INT;   }
and   { return AND;   }
or    { return OR;   }

%%

