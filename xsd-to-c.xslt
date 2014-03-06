<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:transform [
  <!ENTITY s "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>" >
  <!ENTITY s2 "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>  </xsl:text>" >
  <!ENTITY s4 "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>    </xsl:text>" >
  <!ENTITY s6 "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>      </xsl:text>" >
  <!ENTITY e "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'></xsl:text>" >
  <!ENTITY n "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
</xsl:text>" >
]>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:str="http://exslt.org/strings">
<xsl:output method="text"/>

<xsl:template match="/">
#define _XOPEN_SOURCE
#include &lt;axl.h&gt;
#include &lt;stdio.h&gt;
#include &lt;stdbool.h&gt;
#include &lt;stdint.h&gt;
#include &lt;time.h&gt;

#define min(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a &lt; _b ? _a : _b; })

#define STRLEN(x) sizeof(x) - 1
#define S_CMP(x, n, y) (STRLEN(y) == n) &amp;&amp; (strncmp (x, y, n) == 0)


  <xsl:for-each select="//xs:simpleType">
    <xsl:choose>
      <xsl:when test="./xs:restriction/@base = 'xs:string'">
        <xsl:choose>
          <xsl:when test="./xs:restriction/xs:enumeration">
            <xsl:variable name="typename" select="./@name" />

typedef enum {
	<xsl:value-of select="$typename"/>_UNSET = 0<xsl:for-each select="./xs:restriction/xs:enumeration">,
	<xsl:value-of select="$typename"/>_<xsl:value-of select="@value"/>
</xsl:for-each>
} <xsl:value-of select="$typename"/>;
	  </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

  <xsl:for-each select="//xs:simpleType">
    <xsl:choose>
      <xsl:when test="./xs:restriction/@base = 'xs:string'">
        <xsl:choose>
          <xsl:when test="./xs:restriction/xs:enumeration">
            <xsl:variable name="typename" select="./@name" />
static inline
void parse_<xsl:value-of select="$typename"/> (axlNode *node, <xsl:value-of select="$typename"/> *result) {
	int len = 0;
	const char *contents = axl_node_get_content (node, &amp;len);
	<xsl:choose>
		<xsl:when test="count(./xs:restriction/xs:enumeration) = 1">
	if (S_CMP (contents, len, "<xsl:value-of select="./xs:restriction/xs:enumeration/@value"/>"))
		*result = <xsl:value-of select="$typename"/>_<xsl:value-of select="./xs:restriction/xs:enumeration/@value"/>;
		</xsl:when>
		<xsl:otherwise>
	switch (contents[0]) {
	    <!-- TODO: what is required here, isn't implemented in xslt-proc, hence: for-each-group, manually prune -->
	/* TODO: test if the case: should be merged! */
	    <xsl:for-each select="./xs:restriction/xs:enumeration"><xsl:sort select="@value"/>
	case '<xsl:value-of select="substring(@value, 1, 1)" />':
		if (S_CMP (contents, len, "<xsl:value-of select="@value"/>"))
			*result = <xsl:value-of select="$typename"/>_<xsl:value-of select="@value"/>;
		break;
	    </xsl:for-each>
	}
		</xsl:otherwise>
	</xsl:choose>
}
	  </xsl:when>
          <xsl:when test="./xs:restriction/xs:minLength">
#define <xsl:value-of select="@name"/>_minLength <xsl:value-of select="./xs:restriction/xs:minLength/@value" />
typedef const char <xsl:value-of select="@name"/>;
static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
        int len = 0;
        const char *content = axl_node_get_content (node, &amp;len);
        if (len == 0 || len &lt; <xsl:value-of select="@name"/>_minLength) return;
        result = content;
}
	  </xsl:when>
          <xsl:when test="./xs:restriction/xs:minLength and ./xs:restriction/xs:maxLength">
#define <xsl:value-of select="@name"/>_minLength <xsl:value-of select="./xs:restriction/xs:minLength/@value" />
#define <xsl:value-of select="@name"/>_maxLength <xsl:value-of select="./xs:restriction/xs:maxLength/@value" />
typedef const char <xsl:value-of select="@name"/>;
static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
        int len = 0;
        const char *content = axl_node_get_content (node, &amp;len);
        if (len == 0 || len &lt; <xsl:value-of select="@name"/>_minLength || len &gt; <xsl:value-of select="@name"/>_maxLength) return;
        result = content;
}
	  </xsl:when>
          <xsl:otherwise>
typedef const char <xsl:value-of select="@name"/>;
static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
        int len = 0;
        const char *content = axl_node_get_content (node, &amp;len);
        if (len == 0) return;
        result = content;
}
          </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:when test="./xs:restriction/@base = 'xs:int'">
typedef long int <xsl:value-of select="@name"/>;
        <xsl:choose>
          <xsl:when test="./xs:restriction/xs:minInclusive or ./xs:restriction/xs:maxInclusive">
static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
	int len = 0;
	long int tmp;
	const char *content = axl_node_get_content (node, &amp;len);
	if (len == 0) return;
	tmp = strtol (content, NULL, 10);
	<xsl:choose>
          <xsl:when test="./xs:restriction/xs:minInclusive and ./xs:restriction/xs:maxInclusive">
	if (tmp &lt;= <xsl:value-of select="./xs:restriction/xs:minInclusive/@value"/> &amp;&amp; tmp &gt;= <xsl:value-of select="./xs:restriction/xs:maxInclusive/@value"/>) return;
          </xsl:when>
          <xsl:when test="./xs:restriction/xs:minInclusive">
	if (tmp &lt;= <xsl:value-of select="./xs:restriction/xs:minInclusive/@value"/>) return;
          </xsl:when>
          <xsl:when test="./xs:restriction/xs:maxInclusive">
	if (tmp &gt;= <xsl:value-of select="./xs:restriction/xs:maxInclusive/@value"/>) return;
          </xsl:when>
        </xsl:choose>
	*result = tmp;
}
	  </xsl:when>
	  <xsl:otherwise>
static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
	int len = 0;
	const char *content = axl_node_get_content (node, &amp;len);
	if (len == 0) return;
	*result = strtol (content, NULL, 10);
}
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>

      <xsl:when test="./xs:restriction/@base = 'xs:boolean'">
typedef bool <xsl:value-of select="@name"/>;

static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
	int len = 0;
	const char *content = axl_node_get_content (node, &amp;len);
	if (len == 0 || len &lt; 4 || len &gt; 5) return;
	if (strncasecmp (content, "TRUE", len) == 0) *result = true;
	else
	if (strncasecmp (content, "FALSE", len) == 0) *result = false;
}
      </xsl:when>

      <xsl:when test="./xs:restriction/@base = 'xs:date'">
typedef struct tm <xsl:value-of select="@name"/>;

static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
	int len = 0;
	const char *content = axl_node_get_content (node, &amp;len);
	strptime (content, "%F", result);
	result->tm_isdst = -1;
}
      </xsl:when>

	<xsl:when test="./xs:restriction/@base = 'xs:time'">
typedef struct tm <xsl:value-of select="@name"/>;

static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
	int len = 0;
	const char *content = axl_node_get_content (node, &amp;len);
	strptime (content, "%T%z", result);
	result->tm_isdst = -1;
}
      </xsl:when>

      <xsl:when test="./xs:restriction/@base = 'xs:dateTime'">
typedef struct tm <xsl:value-of select="@name"/>;

static inline
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="@name"/> *result) {
	int len = 0;
	const char *content = axl_node_get_content (node, &amp;len);
	strptime (content, "%FT%T%z", result);
	result->tm_isdst = -1;
}
      </xsl:when>

      <!-- TODO: DURATION -->

      <xsl:otherwise>
      /* TODO: <xsl:value-of select="@name"/> */
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

  <xsl:for-each select="//xs:complexType">
  	<xsl:variable name="typename" select="./@name" />
	<xsl:choose>
	<xsl:when test="$typename != ''">
typedef struct {
	<xsl:for-each select="./xs:sequence/xs:element">
		<xsl:value-of select="str:split(@type, ':')[2]"/>&s;*<xsl:value-of select="@name" />;
	</xsl:for-each>
} <xsl:value-of select="$typename"/>;

void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="$typename"/> *result);
	</xsl:when>
	</xsl:choose>
  </xsl:for-each>

  <xsl:for-each select="//xs:complexType">
      <xsl:variable name="typename" select="./@name" />
void parse_<xsl:value-of select="@name"/> (axlNode *node, <xsl:value-of select="$typename"/> *result) {
      <xsl:for-each select="./xs:sequence/xs:element">
           <xsl:choose>
                <xsl:when test="not(@maxOccurs) or @maxOccurs = '1'">
	if (NODE_CMP_NAME (node, "<xsl:value-of select="@name"/>")) {
		parse_<xsl:value-of select="str:split(@type, ':')[2]"/> (node, result-&gt;<xsl:value-of select="@name" />);
		node = axl_node_get_next (node);
	}
		</xsl:when>
		<xsl:otherwise>
	while (NODE_CMP_NAME (node, "<xsl:value-of select="@name"/>")) {
		parse_<xsl:value-of select="str:split(@type, ':')[2]"/> (node, result-&gt;<xsl:value-of select="@name" />);
		node = axl_node_get_next (node);
	}
		</xsl:otherwise>
	   </xsl:choose>
      </xsl:for-each>
}
  </xsl:for-each>
</xsl:template>
</xsl:transform>
