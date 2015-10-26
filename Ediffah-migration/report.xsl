<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/REC-html40"
	xmlns:saxon="http://icl.com/saxon"
	extension-element-prefixes="saxon"
	version="1.1">

<!-- NO REPORTING ON <TABLE> YET. -->

<!-- change report templates -->

<!-- * templates for creating report -->
<xsl:template mode='change' match="*">
	<xsl:apply-templates mode='change' select="*|@*"/>
</xsl:template>

<xsl:template mode='change' match='@*'>
   <xsl:choose>
		<xsl:when test='normalize-space(.)= ""'>
			<xsl:element name='li'>
				<xsl:call-template name='path'/>
				<xsl:text>@</xsl:text>
				<xsl:value-of select='name()'/>
				<xsl:text> had whitespace only value. Attribute was removed.</xsl:text>
				<xsl:element name='br'/>
				<xsl:element name='br'/>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<!-- the following used for testing purposes only
			<xsl:value-of select='name(parent::*)'/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select='name(.)'/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select='.'/>
			<xsl:text>" </xsl:text>
			<br/><br/>
			-->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name='path'>
	<xsl:text>Path: </xsl:text>
	<xsl:for-each select='ancestor::*'>
		<xsl:value-of select='name()'/>
		<xsl:text>[</xsl:text>
		<xsl:number level='single'/>
		<xsl:text>]/</xsl:text>
	</xsl:for-each>
	<xsl:choose>
		<xsl:when test='self::*'>
			<xsl:value-of select='name()'/>
			<xsl:text>[</xsl:text>
			<xsl:number level='single'/>
			<xsl:text>]/</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>@</xsl:text>
			<xsl:value-of select='name()'/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:element name='br'/>
	<xsl:text> Change: </xsl:text>
</xsl:template>

<!-- match eadhead, copy, and apply-templates for change report -->
<xsl:template mode='change' match='eadheader'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:for-each select='@*'>
			<xsl:choose>
				<xsl:when test='name()="langencoding"'>
						<xsl:choose>
							<xsl:when test='contains(normalize-space(.), "639-2")'>
								<xsl:text>@langencoding="</xsl:text>
								<xsl:value-of select='.'/>
								<xsl:text>" changed to "iso639-2b". </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>@langencoding="</xsl:text>
								<xsl:value-of select='@langencoding'/>
								<xsl:text>" changed to "</xsl:text>
								<xsl:value-of select='translate(normalize-space(.), " ", "_")'/>
								<xsl:text>". </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:for-each>
		<xsl:choose>
			<xsl:when test='revisiondesc'>
				<xsl:text>&lt;revisiondesc&gt; revised to with conversion information.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;revisiondesc&gt; added with conversion information.</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:element name='br'/>
		<xsl:element name='br'/>
	</xsl:element>
	<!-- <xsl:copy> -->
		<!-- eadid @ processing -->
	  <xsl:apply-templates mode='change'
     select="eadid|filedesc|profiledesc"/>
<!-- 	</xsl:copy> -->
</xsl:template>
<!-- attribute removal report -->
<xsl:template mode='change'
						  match='@pubstatus[parent::title or parent::titleproper] |
                    @extent[parent::title or parent::titleproper]'>
	<!-- @legalstauts and @otherlegalstatus; @langmaterial handled in did template -->
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:text>@</xsl:text>
		<xsl:value-of select='name()'/>
		<xsl:text>="</xsl:text>
		<xsl:value-of select='.'/>
		<xsl:text>" removed. </xsl:text>
		<xsl:text>This attribute not valid in EAD 2002.</xsl:text>
		<xsl:element name='br'/>
		<xsl:element name='br'/>
	</xsl:element>
</xsl:template>

<!-- render attributes changes-->
<xsl:template mode='change' match='@render[.="boldquoted"] | @render[.="quoted"]'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:text>@</xsl:text>
		<xsl:value-of select='name()'/>
		<xsl:text>="</xsl:text>
		<xsl:value-of select='.'/>
		<xsl:text>" changed to "</xsl:text>
 		<xsl:choose>
  		<xsl:when test='. = "boldquoted"'>
  			<xsl:text>bolddoublequote</xsl:text>
 			</xsl:when>
 			<xsl:when test='. = "quoted"'>
 				<xsl:text>doublequote</xsl:text>
 			</xsl:when>
 			<xsl:otherwise/>
	 	</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:element name='br'/>
		<xsl:element name='br'/>
	</xsl:element>
</xsl:template>
<!-- end render attributes -->

<xsl:template mode='change' match='@othersource'>
<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:text>@</xsl:text>
		<xsl:value-of select='name()'/>
		<xsl:text>="</xsl:text>
		<xsl:value-of select='.'/>
		<xsl:text>" </xsl:text>
		<xsl:choose>
			<xsl:when test='parent::*/@source != "othersource"'>
				<xsl:text>parent element @source did not have value "othersource." </xsl:text>
				<xsl:text>@source value "</xsl:text>
					<xsl:value-of select='parent::*/@source'/>
				<xsl:text>" retained. @othersource value disregarded.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>parent element @source value was "othersource." </xsl:text>
				<xsl:text>@source value changed to "</xsl:text>
					<xsl:value-of select='.'/>
				<xsl:text>".</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:element name='br'/>
		<xsl:element name='br'/>
		</xsl:element>
</xsl:template>

<xsl:template mode='change' match='@othertype[parent::container or parent::archdesc]'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:choose>
			<xsl:when test='parent::*/@type != "othertype"'>
				<xsl:text>@type="othertype" removed. </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>@othertype="</xsl:text>
				<xsl:value-of select='translate(normalize-space(.), " ", "_")'/>
				<xsl:text>" moved to @type. </xsl:text>
				<xsl:choose>
					<xsl:when test='contains(normalize-space(.), " ")'>
						<xsl:text>Whitespace in attribute value was normalized and converted to underscore (_). </xsl:text>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:element name='br'/>
		<xsl:element name='br'/>
	</xsl:element>
</xsl:template>

<xsl:template mode='change' match='@countrycode | @repositorycode'>
	<xsl:if test='contains(.," ") or
								contains(.,".") or
								contains(.,"-") or
								contains(.,":") or
								contains(.,"_")'>
		<xsl:element name='li'>
			<xsl:call-template name='path'/>
			<xsl:text>Whitespace and punctuation ".-:_" in attribute value removed. "</xsl:text>
			<xsl:value-of select='.'/>
			<xsl:text>" changed to "</xsl:text>
			<xsl:value-of select='translate(normalize-space(.), " .-:_", "")'/>
			<xsl:text>". </xsl:text>
			<xsl:element name='br'/>
			<xsl:element name='br'/>
		</xsl:element>
	</xsl:if>
</xsl:template>

<xsl:template mode='change' match='eadid'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:for-each select='@source | @type | @systemid'>
			<xsl:text>@</xsl:text>
			<xsl:value-of select='name()'/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select='.'/>
			<xsl:text>", </xsl:text>
		</xsl:for-each>
   <xsl:if test='@source | @type | @systemid'>
   	<xsl:text> not valid in EAD 2002. Retained as content of &lt;eadid&gt;. </xsl:text>
   </xsl:if>
	<xsl:element name='br'/>
	<xsl:element name='br'/>
	</xsl:element>
</xsl:template>

<!-- did change report -->
<xsl:template mode='change' match='did'>
	<xsl:if test='(parent::*/head and not(*)) or
                    (not(parent::*/head) and not(*)) or
                    (not(*[not(self::head)])) or
                    parent::*[@langmaterial]'>
		<xsl:element name='li'>
			<xsl:call-template name='path'/>
			<!-- first change -->
			<xsl:choose>
				<xsl:when test='parent::*/head and not(*)'>
					<xsl:text>&lt;did&gt; empty. Empty &lt;did&gt; invalid in EAD 2002. &lt;head&gt; on parent element duplicated in &lt;unittitle&gt;.</xsl:text>
				</xsl:when>
				<xsl:when test='not(parent::*/head) and not(*)'>
					<xsl:text>&lt;did&gt; empty. Empty &lt;did&gt; invalid in EAD 2002. Temporary &lt;unittitle&gt; created in &lt;did&gt;. Description needs to be evaluated before publishing.</xsl:text>
				</xsl:when>
				<xsl:when test='not(*[not(self::head)])'>
					<xsl:text>&lt;did&gt; empty except for &lt;head&gt;. &lt;head&gt; and no other elements in &lt;did&gt; invalid in EAD 2002. &lt;head&gt; duplicated in &lt;unittitle&gt;. Description needs to be evaluated before publishing.</xsl:text>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			<xsl:if test='parent::*[@langmaterial]'>
				<xsl:if test='(parent::*/head and not(*)) or
      	              (not(parent::*/head) and not(*)) or
        	            (not(*[not(self::head)]))'>
					<xsl:element name='br'/>
				</xsl:if>
				<xsl:text>&lt;langmaterial&gt; created. For each language code from the parent @langmaterial, a &lt;language&gt;  is created, with language code moved to its @langcode. @langmaterial removed from parent element. </xsl:text>
			</xsl:if>
			<xsl:if test='parent::archdesc'>
				<xsl:element name='br'/>
				<xsl:text>@label supplied on &lt;langmaterial&gt;</xsl:text>
			</xsl:if>
			<xsl:element name='br'/>
			<xsl:element name='br'/>
		</xsl:element>
		<xsl:apply-templates mode='change'
		   select="*|comment()|processing-instruction()|text()"/>
	</xsl:if>

	<xsl:if test='parent::*/@legalstatus or parent::*/@otherlegalstatus'>
		<xsl:element name='li'>
			<xsl:for-each select='parent::*'>
				<xsl:call-template name='path'/>
			</xsl:for-each>
			<xsl:text>&lt;accessrestrict&gt; with child element &lt;legalstatus&gt; added immediately following &lt;did&gt;. </xsl:text>
			<xsl:if test='parent::archdesc'>
				<xsl:element name='br'/>
				<xsl:text>&lt;head&gt; added to &lt;accessrestrict&gt; with content "Legal Status". </xsl:text>
			</xsl:if>
 	  	<xsl:choose>
 	  		<xsl:when test='parent::*/@legalstatus = "public"'>
					<xsl:element name='br'/>
					<xsl:text>Value "public" of @legalstatus moved to legalstatus/@type and value "Public" duplicated as content of element. @legalstatus removed from parent element.</xsl:text>
   			</xsl:when>
   			<xsl:when test='parent::*/@legalstatus = "private"'>
					<xsl:element name='br'/>
					<xsl:text>Value "private" of @legalstatus moved to legalstatus/@type and value "Private" duplicated as content of element. @legalstatus removed from parent element.</xsl:text>
  	 		</xsl:when>
   			<xsl:when test='parent::*/@otherlegalstatus'>
					<xsl:element name='br'/>
					<xsl:text>Value "</xsl:text>
					<xsl:value-of select='parent::*/@otherlegalstatus'/>
					<xsl:text>" of @otherlegalstatus </xsl:text>
					<xsl:if test='contains(parent::*/@otherlegalstatus, " ")'>
						<xsl:text>, with whitespace replaced by underscore, </xsl:text>
					</xsl:if>
					<xsl:text>moved to legalstatus/@type and the same value </xsl:text>
					<xsl:text> duplicated as content of element. @legalstatus and @otherlegalstatus removed from parent element.</xsl:text>
  	 		</xsl:when>
   			<xsl:otherwise/>
 	  	</xsl:choose>
			<xsl:element name='br'/>
			<xsl:element name='br'/>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!-- unitdate report -->
<xsl:template mode='change' match='@type[parent::unitdate]'>
	<xsl:if test='.="single"'>
		<xsl:element name='li'>
			<xsl:call-template name='path'/>
			<xsl:text>changed to @datechar="single"</xsl:text>
			<xsl:element name='br'/>
			<xsl:element name='br'/>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!-- organization report -->
<xsl:template mode='change' match='organization'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:text>&lt;organization&gt; changed to &lt;arrangement&gt;.
&lt;organization&gt; not valid in EAD 2002.</xsl:text>
	<xsl:element name='br'/>
	<xsl:element name='br'/>
	</xsl:element>
	<xsl:apply-templates mode='change' select='* | @*'/>
</xsl:template>

<!-- admininfo report -->
<xsl:template mode='change' match='admininfo'>
	<xsl:call-template name='unbundlereport'>
		<xsl:with-param name='localname'>admininfo</xsl:with-param>
		<xsl:with-param name='descs' select='accessrestrict | acqinfo |
                       altformavail | appraisal |
                       custodhist | prefercite |
                       processinfo | userestrict |
                       accruals | admininfo'/>
	</xsl:call-template>
</xsl:template>

<xsl:template name='unbundlereport'>
	<!-- The following two variables used for counting the number
       of "unbundled" desc and block elements that are children
       of admininfo or add, respectively $descs and $blocks
	-->
	<xsl:param name='localname'/>
	<xsl:param name='descs'/>
	<xsl:variable name='blocks' select='address | chronlist | list |
                       note | table | p | blockquote'/>

	<xsl:choose>
		<!-- (count($blocks) = 0) and (count($descs) = 0) invalid; no
         test necessary
		-->
		<xsl:when test='(count($blocks) &gt; 0) and (count($descs) = 0)'>
			<xsl:element name='li'>
  			<xsl:call-template name='path'/>
     		<xsl:text>converted to &lt;odd&gt;. &lt;</xsl:text>
				<xsl:value-of select='name()'/>
				<xsl:text>&gt; contained block elements and no descriptive elements. </xsl:text>
				<xsl:if test='not(@type)'>
					<xsl:text>@type added with value set to parent element name: "</xsl:text>
					<xsl:value-of select='name()'/>
					<xsl:text>". </xsl:text>
				</xsl:if>
				<xsl:text>[unbundle type 1]</xsl:text>
				<xsl:element name='br'/>
				<xsl:element name='br'/>
			</xsl:element>
			<xsl:apply-templates mode='change'
					 select="*|@*|comment()|processing-instruction()"/>
		</xsl:when>
		<xsl:when test='(count($blocks) = 0) and (count($descs) = 1) '>
			<xsl:choose>

				<xsl:when test='head and */head'>
					<xsl:element name='li'>
  					<xsl:call-template name='path'/>
        		<xsl:text>Discarded parent &lt;</xsl:text>
   					<xsl:value-of select='name()'/>
   					<xsl:text>&gt; and its &lt;head&gt; Text of discarded &lt;head&gt;: "</xsl:text>
						<xsl:value-of select='head'/>
						<xsl:text>" </xsl:text>
						<xsl:text>[unbundle type 2]</xsl:text>
						<xsl:element name='br'/>
						<xsl:element name='br'/>
					</xsl:element>
					<xsl:apply-templates mode='change'
							select="*[not(self::head)]|comment()|processing-instruction()"/>
				</xsl:when>

				<xsl:when test='head and not(*/head)'>
					<xsl:for-each select='$descs'>
						<xsl:choose>
							<xsl:when test='name()=$localname'>
      					<xsl:element name='li'>
        					<xsl:call-template name='path'/>
									<xsl:text>parent &lt;</xsl:text>
									<xsl:value-of select='$localname'/>
              		<xsl:text>&gt; and &lt;head&gt; discarded. Text of </xsl:text>
									<xsl:text>discarded &lt;head&gt; "</xsl:text>
									<xsl:value-of select='parent::*/head'/>
									<xsl:text>". </xsl:text>
									<xsl:text>[unbundle type 3]</xsl:text>
      						<xsl:element name='br'/>
      						<xsl:element name='br'/>
      					</xsl:element>
 						 	  <xsl:apply-templates mode='change'
   								 select="*|comment()|processing-instruction()"/>
							</xsl:when>
							<xsl:otherwise>
      					<xsl:element name='li'>
        					<xsl:call-template name='path'/>
									<xsl:text>&lt;</xsl:text>
									<xsl:value-of select='name()'/>
									<xsl:text>&gt; retained. &lt;head&gt; of parent &lt;</xsl:text>
									<xsl:value-of select='$localname'/>
									<xsl:text>&gt; moved to this element, as it had none. </xsl:text>
									<xsl:text>[unbundle type 4]</xsl:text>
									<xsl:element name='br'/>
									<xsl:element name='br'/>
								</xsl:element>
								<xsl:apply-templates mode='change'
										 select="*|comment()|processing-instruction()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select='$descs'>
						<xsl:choose>
							<xsl:when test='$localname=name()'>
								 <xsl:element name='li'>
        					<xsl:call-template name='path'/>
									<xsl:text>&lt;</xsl:text>
									<xsl:value-of select='$localname'/>
									<xsl:text>&gt; removed. This element, &lt;</xsl:text>
									<xsl:value-of select='$localname'/>
									<xsl:text>&gt; passed through for further processing. </xsl:text>
									<xsl:text>[unbundle type 5]</xsl:text>
									<xsl:element name='br'/>
									<xsl:element name='br'/>
								</xsl:element>
 						 	  <xsl:apply-templates mode='change'
   								  select="*|comment()|processing-instruction()"/>
							</xsl:when>
							<xsl:otherwise>
								 <xsl:element name='li'>
        					<xsl:call-template name='path'/>
									<xsl:text>&lt;</xsl:text>
									<xsl:value-of select='$localname'/>
									<xsl:text>&gt; removed. This element, &lt;</xsl:text>
									<xsl:value-of select='name()'/>
									<xsl:text>&gt;, copied into output. </xsl:text>
									<xsl:text>[unbundle type 6]</xsl:text>
									<xsl:element name='br'/>
									<xsl:element name='br'/>
								</xsl:element>
								<xsl:apply-templates mode='change'
									 select="*|@*|comment()|processing-instruction()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test='not(head) and (count($blocks) = 0) and (count($descs) &gt; 1)'>
			<xsl:element name='li'>
 				<xsl:call-template name='path'/>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select='$localname'/>
				<xsl:text>&gt; removed, as it had no &lt;head&gt;. </xsl:text>
				<xsl:text>[unbundle type 7]</xsl:text>
				<xsl:element name='br'/>
				<xsl:element name='br'/>
			</xsl:element>
				<xsl:apply-templates mode='change'
					 select="*|comment()|processing-instruction()"/>
		</xsl:when>
		<xsl:otherwise>
			<!-- Covers: head, blocks = 0 and descs > 1
                   blocks > 0 and descs > 0	-->
			<xsl:element name='li'>
 				<xsl:call-template name='path'/>
				<xsl:text>&lt;</xsl:text>
				<xsl:value-of select='$localname'/>
				<xsl:text>&gt; changed to &lt;descgrp&gt;. </xsl:text>
				<xsl:if test='not(@type)'>
					<xsl:text>@type added with value "</xsl:text>
					<xsl:value-of select='$localname'/>
					<xsl:text>". </xsl:text>
				</xsl:if>
				<xsl:text>[unbundle type 8]</xsl:text>
				<xsl:element name='br'/>
				<xsl:element name='br'/>
			</xsl:element>
			<xsl:apply-templates mode='change'
					 select="*|@*|comment()|processing-instruction()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template mode='change' match='ref | ptr | dao | extptr | extref | title | archref | bibref'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:choose>
			<xsl:when test='(count(@behavior | @inline |
                        	@content-role | @content-title)) &gt; 1'>
				<xsl:text>The following attributes removed. Not valid in 2002.&#13;</xsl:text>
			</xsl:when>
			<xsl:when test='(count(@behavior | @inline |
                        	@content-role | @content-title)) = 1'>
				<xsl:text>The following attribute removed. Not valid in 2002.&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
		<xsl:for-each select='@behavior | @inline |
                        	@content-role | @content-title'>
			<xsl:text> @</xsl:text>
			<xsl:value-of select='name()'/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select='.'/>
			<xsl:text>". </xsl:text>
		</xsl:for-each>
		<xsl:if test='@actuate'>
			<xsl:choose>
				<xsl:when test='@actuate = "auto"'>
					<xsl:text>@actuate="auto" converted to @actuate="onload". </xsl:text>
				</xsl:when>
				<xsl:when test='@actuate = "user"'>
					<xsl:text>@actuate="user" converted to @actuate="onrequest". </xsl:text>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:if>
		<xsl:element name='br'/>
		<xsl:element name='br'/>
	</xsl:element>
	<xsl:for-each select='@*'>
		<xsl:choose>
			<xsl:when test='name()="inline" or
											name()="content-role" or
											name()="content-title"'/>
			<xsl:otherwise>
				<xsl:apply-templates mode='change' select='.'/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
  <xsl:apply-templates mode='change'
   	 select="*|comment()|processing-instruction()"/>
</xsl:template>

<xsl:template mode='change' match='daogrp | linkgrp'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:choose>
			<xsl:when test='(count(@content-title | @content-role)) &gt; 1'>
				<xsl:text>The following attributes removed. Not valid in 2002. </xsl:text>
			</xsl:when>
			<xsl:when test='(count(@content-title | @content-role)) = 1'>
				<xsl:text>The following attribute removed. Not valid in 2002. </xsl:text>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
		<xsl:for-each select='@content-title | @content-role'>
			<xsl:text> @</xsl:text>
			<xsl:value-of select='name()'/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select='.'/>
			<xsl:text>". </xsl:text>
		</xsl:for-each>
		<xsl:text>&lt;resource&gt; created with @label="start". '</xsl:text>
		<xsl:for-each select='daoloc | extptrloc | extrefloc'>
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select='name()'/>
			<xsl:text>&gt; copied to output </xsl:text>
			<xsl:if test='@altrender | @audience | @entityref |
                          @href | @id | @role | @title |
                          @xpointer'>
				<xsl:text>with the following attribute(s): </xsl:text>
			</xsl:if>
			<xsl:for-each select='@altrender | @audience | @entityref |
                         @href | @id | @role | @title |
                         @xpointer'>
				<xsl:text>@</xsl:text>
				<xsl:value-of select='name()'/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select='.'/>
				<xsl:text>" </xsl:text>
			</xsl:for-each>
			<xsl:text>@label="resource-</xsl:text>
			<xsl:value-of select='position()'/>
			<xsl:text>" </xsl:text>
			<xsl:text>Element &lt;arc&gt; added </xsl:text>
			<xsl:if test='@show'>
				<xsl:text>with @show="</xsl:text>
				<xsl:value-of select='@show'/>
				<xsl:text>" moved from &lt;</xsl:text>
				<xsl:value-of select='name()'/>
				<xsl:text>&gt; and </xsl:text>
			</xsl:if>
			<xsl:text>with attributes @from="start" and @to="resource-</xsl:text>
				<xsl:value-of select='position()'/>
			<xsl:text>".</xsl:text>
		</xsl:for-each>
		<xsl:element name='br'/>
		<xsl:element name='br'/>
	</xsl:element>
</xsl:template>

<!--table to be completed************************************************************-->


<xsl:template mode='change' match='table'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:if test='@orient | @shortentry | @tabstyle | @tocentry'>
			<xsl:text>The following attribute</xsl:text>
			<xsl:choose>
				<xsl:when test='count(@orient | @shortentry | @tabstyle | @tocentry) &gt; 1'>
				 <xsl:text>s</xsl:text>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>

			<xsl:text> removed: </xsl:text>
			<xsl:for-each select='@orient | @shortentry | @tabstyle | @tocentry'>
				<xsl:text>@</xsl:text>
				<xsl:value-of select='name(.)'/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select='.'/>
				<xsl:text>". </xsl:text>
			</xsl:for-each>
			<xsl:text>Not valid in OASIS XML table used in EAD 2002. </xsl:text>
		</xsl:if>
		<br/><br/>
	</xsl:element> <!-- li -->

	<xsl:apply-templates mode='change'
		   select="*"/>
</xsl:template>


<xsl:template mode='change' match='tgroup'>
		<xsl:if test='@char | @charoff | @tgroupstyle'>
			<xsl:element name='li'>
				<xsl:call-template name='path'/>
					<xsl:text>The following attribute</xsl:text>
					<xsl:choose>
						<xsl:when test='count(@char | @charoff | @tgroupstyle) &gt; 1'>
					 	<xsl:text>s</xsl:text>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
					<xsl:text> removed: </xsl:text>
					<xsl:for-each select='@char | @charoff | @tgroupstyle'>
						<xsl:text>@</xsl:text>
						<xsl:value-of select='name(.)'/>
						<xsl:text>="</xsl:text>
						<xsl:value-of select='.'/>
						<xsl:text>". </xsl:text>
					</xsl:for-each>
					<xsl:text>Not valid in OASIS XML table used in EAD 2002. </xsl:text>
					<br/>
					<br/>
			</xsl:element> <!-- li -->
		</xsl:if>
		<xsl:apply-templates mode='change' select='*'/>
</xsl:template>


<xsl:template mode='change' match='thead'>
	<xsl:apply-templates mode='change' select='row'/>
</xsl:template>

<xsl:template mode='change' match='spanspec'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:text>Removed. Not valid in EAD 2002. </xsl:text>
		<xsl:text>&lt;spanspec&gt; in source had the following attributes and values: </xsl:text>
		<xsl:for-each select='@*'>
			<xsl:value-of select='name()'/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select='.'/>
			<xsl:text>" </xsl:text>
		</xsl:for-each>
		<br/><br/>
	</xsl:element>
</xsl:template>

<xsl:template mode='change' match='tfoot'>
	<xsl:element name='li'>
		<xsl:call-template name='path'/>
		<xsl:text>Removed. Not valid in EAD 2002. </xsl:text>
		<xsl:text>Each &lt;row&gt; converted to trailing row in &lt;tbody&gt; with </xsl:text>
		<xsl:text>@altrender="tfoot". </xsl:text>
		<xsl:for-each select='colspec'>
			<xsl:text>&lt;colspec&gt; removed. &lt;colspec&gt; had the following </xsl:text>
			<xsl:text>attributes: </xsl:text>
			<xsl:for-each select='@*'>
				<xsl:value-of select='name()'/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select='.'/>
				<xsl:text>" </xsl:text>
			</xsl:for-each>
		</xsl:for-each>
		<br/><br/>
	</xsl:element>
	<xsl:apply-templates mode='change' select='row'/>
</xsl:template>

<xsl:template mode='change' match='row'>
	<xsl:if test='entry[@rotate!="0" or @spanname]'>
		<xsl:element name='li'>
			<xsl:call-template name='path'/>
			<xsl:text>The following &lt;entry&gt; elements had attributes removed. </xsl:text>
			<xsl:text>Not valid in OASIS XML table used in EAD 2002. </xsl:text>
			<xsl:for-each select='entry[@rotate | @spanname]'>
				<xsl:if test='not(@rotate="0")'>
					<br/>
					<xsl:text>entry[</xsl:text>
					<xsl:value-of select='position()'/>
					<xsl:text>]: </xsl:text>
					<xsl:for-each select='@rotate | @spanname'>
						<xsl:value-of select='name()'/>
						<xsl:text>="</xsl:text>
						<xsl:value-of select='.'/>
						<xsl:text>" </xsl:text>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
			<br/><br/>
		</xsl:element>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
