<xsl:stylesheet version="2.0" xmlns:m="http://www.loc.gov/MARC21/slim"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead="http://www.loc.gov/ead/" xmlns:local="local-functions"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xsl xml ead local xlink xs">

    <xsl:param name="currentDate"/>

    <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>

    <xsl:template match="/">
        <collection>
            <xsl:variable name="coverYears" select="replace(ead/archdesc/did/unitdate,'[^0-9]','')"/>

            <xsl:variable name="coverYear1"
                select="replace(substring-before(ead/archdesc/did/unitdate,'--'),'[^0-9]','')"/>

            <xsl:variable name="coverYear2" 
                select="replace(substring-after(ead/archdesc/did/unitdate,'--'),'[^0-9]','')"/>

            <xsl:variable name="coverYear1s"
                select="normalize-space(substring-before(substring-before(ead/archdesc/did/unitdate,'--'),','))"/>

            <xsl:variable name="coverYear2s"
                select="normalize-space(substring-after(substring-after(ead/archdesc/did/unitdate,'--'),','))"/>


            <xsl:variable name="countCYrs" select="string-length($coverYears)"/>

            <xsl:variable name="countCYr1" select="string-length($coverYear1)"/>

            <xsl:variable name="countCYr2" select="string-length($coverYear2)"/>

            <xsl:variable name="langSpec" select="ead/archdesc/did/langmaterial/language/node()"/>
            <xsl:variable name="langCode" select="ead/archdesc/did/langmaterial/language/@langcode"/>
            <xsl:variable name="langSpecItems" as="item()*"
                select="('Svenska','Arabiska','Danska','Engelska','Estniska','Finska','Fornisländska','Grekiska','Franska','Hebreiska','Italienska','Isländska','Latin','Norska','Polska','Portugisiska','Ryska','Rätoromanska','Spanska','Turkiska','Tyska','Flerspråkigt',' ')"/>
            <xsl:variable name="langCodeItems" as="item()*"
                select="('swe','ara','dan','eng','est','fin','non','grc','fre','heb','ita','ice','lat','nor','pol','por','rus','roh','spa','tur','ger','mul','und')"/>
            <xsl:variable name="indexLang" select="index-of($langSpecItems,$langSpec)"/>
            <xsl:variable name="indexCode" select="index-of($langCodeItems,$langCode)"/>
            <xsl:variable name="langmap"
                select="for $i in $langSpec return $langCodeItems[position() = $indexLang]"/>
            <xsl:variable name="langtrans"
                select="if (empty($langSpec) or not($langSpec) or not($langSpec=($langSpecItems))) then 'und' else $langmap"/>
            <xsl:variable name="language"
                select="if ($langCode=($langCodeItems)) then $langCode else $langtrans"/>

            <xsl:variable name="cFdate" select="format-date(current-date(),'[Y00][M,2][D,2]')"/>


            <xsl:variable name="unsorted">
                <xsl:if test="exists(ead/archdesc/dsc)">

                    <record type="Bibliographic">



                        <leader>XXXXXntc a22XXXXX7c 4500</leader>

                        <controlfield tag="001">
                            <xsl:value-of select="ead/eadheader/eadid/@identifier"/>
                        </controlfield>

                        <xsl:variable name="pos0to39"
                            select="concat($cFdate,'i',$coverYears,'sw ||||  |||| ||| ||',$language[1],' c')"/>

                        <xsl:variable name="pos0to39uu"
                            select="concat($cFdate,'i','uuuuuuuu','sw ||||  |||| ||| ||',$language[1],' c')"/>

                        <controlfield tag="008">
                            <xsl:if test="contains(ead/archdesc/did/unitdate,'--')">
                                <xsl:choose>
                                    <xsl:when test="($countCYr1 &gt; 4) and ($countCYr2 &gt; 4)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',replace($coverYear1,substring-after($coverYear1,$coverYear1s),''),replace($coverYear2,substring-before($coverYear2,$coverYear2s),''),'sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 &gt; 4) and ($countCYr2 = 4)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',replace($coverYear1,substring-after($coverYear1,$coverYear1s),''),$coverYear2,'sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 = 4) and ($countCYr2 &gt; 4)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,replace($coverYear2,substring-before($coverYear2,$coverYear2s),''),'sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>

                                    <xsl:when test="($countCYr1 = 4) and ($countCYr2 = 3)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,$coverYear2,'u','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 = 4) and ($countCYr2 = 2)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,$coverYear2,'uu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 = 4) and ($countCYr2 = 1)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,$coverYear2,'uuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 = 4) and ($countCYr2 = 0)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,$coverYear2,'uuuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>

                                    <xsl:when test="($countCYr1 = 0) and ($countCYr2 = 4)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'uuuu',$coverYear2,'sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 = 1) and ($countCYr2 = 4)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'uuu',$coverYear2,'sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 = 2) and ($countCYr2 = 4)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'uu',$coverYear2,'sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 = 3) and ($countCYr2 = 4)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'u',$coverYear2,'sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="($countCYr1 = 3) and ($countCYr2 = 3)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'u',$coverYear2,'u','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="contains(ead/archdesc/did/unitdate,'--') and ($countCYr1 = 3) and ($countCYr2 = 2)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'u',$coverYear2,'uu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="contains(ead/archdesc/did/unitdate,'--') and ($countCYr1 = 3) and ($countCYr2 = 1)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'u',$coverYear2,'uuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="contains(ead/archdesc/did/unitdate,'--') and ($countCYr1 = 1) and ($countCYr2 = 3)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'uuu',$coverYear2,'u','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="contains(ead/archdesc/did/unitdate,'--') and ($countCYr1 = 2) and ($countCYr2 = 3)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'uu',$coverYear2,'u','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="contains(ead/archdesc/did/unitdate,'--') and ($countCYr1 = 2) and ($countCYr2 = 2)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'uu',$coverYear2,'uu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="contains(ead/archdesc/did/unitdate,'--') and ($countCYr1 = 2) and ($countCYr2 = 1)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'uu',$coverYear2,'uuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="contains(ead/archdesc/did/unitdate,'--') and ($countCYr1 = 1) and ($countCYr2 = 2)">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYear1,'uuu',$coverYear2,'uu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <xsl:value-of select="$pos0to39"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="not(contains(ead/archdesc/did/unitdate,'--'))">
                                <xsl:choose>
                                    <xsl:when test="$countCYrs = 7">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYears,'u','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$countCYrs = 6">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYears,'uu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$countCYrs = 5">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYears,'uuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$countCYrs = 4">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYears,'uuuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$countCYrs = 3">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYears,'uuuuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$countCYrs = 2">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYears,'uuuuuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when test="$countCYrs = 1">
                                        <xsl:value-of
                                            select="concat($cFdate,'i',$coverYears,'uuuuuuu','sw ||||  |||| ||| ||',$language[1],' c')"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="($countCYrs = 0) or not(ead/archdesc/did/unitdate)">
                                        <xsl:value-of select="$pos0to39uu"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$pos0to39"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </controlfield>

                        <datafield tag="024" ind2=" " ind1="8">
                            <subfield code="a">
                                <xsl:value-of select="normalize-space(ead/eadheader/eadid)"/>
                            </subfield>
                            <subfield code="q">(KB-signum)</subfield>
                        </datafield>

                        <datafield tag="035" ind2=" " ind1=" ">
                            <subfield code="a">
                                <xsl:value-of select="ead/eadheader/eadid/@identifier"/>
                            </subfield>
                        </datafield>

                        <datafield tag="040" ind2=" " ind1=" ">
                            <subfield code="a">S</subfield>
                        </datafield>

                        <datafield tag="042" ind2=" " ind1=" ">
                            <subfield code="9">HARK</subfield>
                        </datafield>

                        <xsl:if
                            test="exists(ead/archdesc/controlaccess/subject[@source='lokal_klassning'])">
                            <datafield tag="084" ind2=" " ind1=" ">
                                <subfield code="a">
                                    <xsl:value-of
                                        select="ead/archdesc/controlaccess/subject[@source='lokal_klassning']/node()"
                                    />
                                </subfield>
                                <subfield code="q">KB:s handskriftssamling</subfield>
                            </datafield>
                        </xsl:if>

                        <xsl:variable name="archivistAll" select="ead/archdesc/did/origination/(persname,famname,name,corpname)"/>

                        <xsl:for-each select="$archivistAll">
                            

                           
                            <xsl:variable name="archivistName"
                                select="ead/archdesc/did/origination/(persname,famname,name)"/>
                           
                           
                            
                            

                         <!-- Här följer fält för förstnämnda arkivbildare i 100: -->
                            
                            
                         <xsl:choose>
                            <xsl:when
                                test="position() = 1 and (node()[parent::persname,parent::famname,parent::name])">
                                
                                
                                    
                                    <xsl:variable name="livingStartYr"
                                        select="replace(substring-before(substring-after(.,'('),'-'),'[^0-9]','')"/>
                                    <xsl:variable name="livingEndYr"
                                        select="replace(substring-after(substring-after(.,'('),'-'),'[^0-9]','')"/>
                                <xsl:variable name="livingStartYr1"
                                    select="replace(substring-before(substring-before(.,';'),'-'),'[^0-9]','')"/>
                                <xsl:variable name="livingEndYr1"
                                    select="replace(substring-after(substring-before(.,';'),'-'),'[^0-9]','')"/>
                                
                                <xsl:variable name="livingStartYr2"
                                    select="replace(substring-before(substring-after(.,';'),'-'),'[^0-9]','')"/>
                                <xsl:variable name="livingEndYr2"
                                    select="replace(substring-after(substring-after(.,';'),'-'),'[^0-9]','')"/>
                                
                                <xsl:variable name="cleanName1" select="normalize-space(concat(tokenize(replace(.,';',','),',\s*')[1],', ', tokenize(replace(.,';',','),',\s*')[2]))"/>
                                <xsl:variable name="cleanName2" select="normalize-space(substring-before(concat(tokenize(substring-after(.,';'),',\s*')[1],', ',tokenize(substring-after(.,';'),',\s*')[2]),'('))"/>
                                
                                    
                                    
                                    <datafield tag="100" ind2=" ">
                                        <xsl:attribute name="ind1" select="if(node()[parent::persname]) then '1' else if(node()[parent::famname]) then '3' else '0'"/> 
                                       
                                        <subfield code="a">
                                           <xsl:choose>
                                                <xsl:when test="contains(.,'(')"> 
                                                  <xsl:value-of select="normalize-space(replace(substring-before(.,'('),'[0-9\()]',''))"/>
                                                </xsl:when>
                                              
                                               <xsl:otherwise>
                                                   <xsl:value-of select="$cleanName1"/>
                                               </xsl:otherwise>
                                           </xsl:choose>  
                                        </subfield>
                                        
                                        <xsl:if test="matches(.,'[0-9]')">
                                            <subfield code="d">
                                              <xsl:choose>
                                               <xsl:when test="contains(.,';')">  
                                                <xsl:value-of
                                                    select="normalize-space(concat($livingStartYr1,'-',$livingEndYr1))"/>
                                               </xsl:when> 
                                                <xsl:otherwise>  
                                                      <xsl:value-of
                                                          select="normalize-space(concat($livingStartYr,'-',$livingEndYr))"/>
                                                  </xsl:otherwise>    
                                              </xsl:choose>    
                                            </subfield>
                                        </xsl:if>
                                        
                                        
                                        <xsl:if test="exists(parent::origination/@label)">
                                            <subfield code="e">
                                                <xsl:value-of
                                                    select="lower-case(substring-before(parent::origination/@label,':'))"
                                                />
                                            </subfield>
                                        </xsl:if>
                                    </datafield>
                                    
                                <xsl:if test="contains(.,';')">
                                    <datafield tag="700" ind2=" ">
                                        <xsl:attribute name="ind1" select="if(node()[parent::persname]) then '1' else if(node()[parent::famname]) then '3' else '0'"/>  
                                        <subfield code="a">
                                            <xsl:value-of select="$cleanName2"/>
                                        </subfield>  
                                        <subfield code="d"> 
                                            <xsl:value-of
                                                select="normalize-space(concat($livingStartYr2,'-',$livingEndYr2))"/>
                                        </subfield>  
                                        <xsl:if test="exists(parent::origination/@label)">
                                            <subfield code="e">
                                                <xsl:value-of
                                                    select="lower-case(substring-before(parent::origination/@label,':'))"
                                                />
                                            </subfield>
                                        </xsl:if>
                                    </datafield>     
                                </xsl:if>
                                    
                                </xsl:when>
                              
                                
                             <xsl:when test="position() = 1 and (node()[parent::corpname])">
                                  
                                  <xsl:variable name="livingStartYr"
                                      select="replace(substring-before(.,'-'),'[^0-9]','')"/>
                                  <xsl:variable name="livingEndYr"
                                      select="replace(substring-after(.,'-'),'[^0-9]','')"/>
                                   
                                    <datafield tag="110" ind2=" " ind1="2">
                                        
                                        <subfield code="a">
                                            <xsl:value-of
                                                select="normalize-space(replace(.,'[0-9\-()]',''))"
                                            />
                                        </subfield>
                                        <xsl:if test="matches(.,'[0-9]')">
                                            <subfield code="d">
                                                <xsl:value-of
                                                    select="normalize-space(concat($livingStartYr,'-',$livingEndYr))"
                                                />
                                            </subfield>
                                        </xsl:if>
                                        
                                        
                                        <xsl:if test="exists(parent::origination/@label)">
                                            <subfield code="e">
                                                <xsl:value-of
                                                    select="lower-case(substring-before(parent::origination/@label,':'))"
                                                />
                                            </subfield>
                                        </xsl:if>
                                    </datafield>
                                    
                                
                               </xsl:when>          
                             
                                 

                            <!-- Här följer fält för fler än 1 arkivbildare  - personer eller släkter i 700: -->

                             <xsl:when test="position() &gt; 1 and (node()[parent::persname,parent::famname,parent::name])">
                                 
                                 <xsl:variable name="livingStartYr"
                                     select="replace(substring-before(substring-after(.,'('),'-'),'[^0-9]','')"/>
                                 <xsl:variable name="livingEndYr"
                                     select="replace(substring-after(substring-after(.,'('),'-'),'[^0-9]','')"/>
                                 
                                 <xsl:variable name="livingStartYr1"
                                     select="replace(substring-before(substring-before(.,';'),'-'),'[^0-9]','')"/>
                                 <xsl:variable name="livingEndYr1"
                                     select="replace(substring-after(substring-before(.,';'),'-'),'[^0-9]','')"/>
                                 <xsl:variable name="livingStartYr2"
                                     select="replace(substring-before(substring-after(.,';'),'-'),'[^0-9]','')"/>
                                 <xsl:variable name="livingEndYr2"
                                     select="replace(substring-after(substring-after(.,';'),'-'),'[^0-9]','')"/>
                                 
                                 <xsl:variable name="cleanName1" select="normalize-space(concat(tokenize(replace(.,';',','),',\s*')[1],', ', tokenize(replace(.,';',','),',\s*')[2]))"/>
                                 <xsl:variable name="cleanName2" select="normalize-space(substring-before(concat(tokenize(substring-after(.,';'),',\s*')[1],', ',tokenize(substring-after(.,';'),',\s*')[2]),'('))"/>

                               
                                       <datafield tag="700" ind2=" ">
                                           <xsl:attribute name="ind1" select="if(node()[parent::persname]) then '1' else if(node()[parent::famname]) then '3' else '0'"/> 
                                           
                                           <subfield code="a">
                                               <xsl:choose>
                                                   <xsl:when test="contains(.,'(')"> 
                                                       <xsl:value-of select="normalize-space(replace(substring-before(.,'('),'[0-9\()]',''))"/>
                                                   </xsl:when>
                                                   
                                                   <xsl:otherwise>
                                                       <xsl:value-of select="$cleanName1"/>
                                                   </xsl:otherwise>
                                               </xsl:choose>  
                                           </subfield>
                                          
                                           <xsl:if test="matches(.,'[0-9]')">
                                               <subfield code="d">
                                                   <xsl:choose>
                                                       <xsl:when test="contains(.,';')">  
                                                           <xsl:value-of
                                                               select="normalize-space(concat($livingStartYr1,'-',$livingEndYr1))"/>
                                                       </xsl:when> 
                                                       <xsl:otherwise>  
                                                           <xsl:value-of
                                                               select="normalize-space(concat($livingStartYr,'-',$livingEndYr))"/>
                                                       </xsl:otherwise>    
                                                   </xsl:choose>    
                                               </subfield>
                                           </xsl:if>


                                        <xsl:if test="exists(parent::origination/@label)">
                                            <subfield code="e">
                                                <xsl:value-of
                                                  select="lower-case(substring-before(parent::origination/@label,':'))"
                                                />
                                            </subfield>
                                        </xsl:if>
                                    </datafield>
                                    
                                 <xsl:if test="contains(.,';')">
                                     <datafield tag="700" ind2=" ">
                                         <xsl:attribute name="ind1" select="if(node()[parent::persname]) then '1' else if(node()[parent::famname]) then '3' else '0'"/>  
                                         <subfield code="a">
                                             <xsl:value-of select="$cleanName2"/>
                                         </subfield>  
                                         <subfield code="d"> 
                                             <xsl:value-of
                                                 select="normalize-space(concat($livingStartYr2,'-',$livingEndYr2))"/>
                                         </subfield>  
                                         <xsl:if test="exists(parent::origination/@label)">
                                             <subfield code="e">
                                                 <xsl:value-of
                                                     select="lower-case(substring-before(parent::origination/@label,':'))"
                                                 />
                                             </subfield>
                                         </xsl:if>
                                     </datafield>     
                                 </xsl:if>
                                
                                 </xsl:when>
                               
                             <xsl:when test="position() &gt; 1 and (node()[parent::corpname])">
                                    
                                    <xsl:variable name="livingStartYr"
                                        select="replace(substring-before(.,'-'),'[^0-9]','')"/>
                                    <xsl:variable name="livingEndYr"
                                        select="replace(substring-after(.,'-'),'[^0-9]','')"/>
                                                                      
                                    <datafield tag="710" ind2=" " ind1="2">
                                                            
                                        <subfield code="a">
                                            <xsl:value-of
                                                select="normalize-space(replace(.,'[0-9\-()]',''))"
                                            />
                                        </subfield>
                                        <xsl:if test="matches(.,'[0-9]')">
                                            <subfield code="d">
                                                <xsl:value-of
                                                    select="normalize-space(concat($livingStartYr,'-',$livingEndYr))"
                                                />
                                            </subfield>
                                        </xsl:if>
                                        
                                        
                                        <xsl:if test="exists(parent::origination/@label)">
                                            <subfield code="e">
                                                <xsl:value-of
                                                    select="lower-case(substring-before(parent::origination/@label,':'))"
                                                />
                                            </subfield>
                                        </xsl:if>
                                    </datafield>
                                    
                             </xsl:when>
                        </xsl:choose>
                          
                       </xsl:for-each>                        
                        
                        <!-- Slut på 700/710 -->
                        

                        <xsl:if test="exists(ead/eadheader/filedesc/titlestmt/titleproper)">
                            <datafield tag="245" ind2="0" ind1="1">
                                <subfield code="a">
                                    <xsl:value-of
                                        select="ead/eadheader/filedesc/titlestmt/titleproper"/>
                                </subfield>

                                <xsl:if test="matches(ead/archdesc/did/unitdate,'[0-9]')">
                                    <subfield code="f">
                                        <xsl:value-of select="ead/archdesc/did/unitdate"/>
                                    </subfield>
                                </xsl:if>
                                <subfield code="h">[Personarkiv]</subfield>

                            </datafield>

                        </xsl:if>

                        <xsl:if test="exists(ead/archdesc/did/physdesc/extent)">
                            <datafield tag="300" ind2=" " ind1=" ">
                                <xsl:choose>
                                    <xsl:when
                                        test="matches(/ead/archdesc[1]/did/physdesc/extent[2],'[1-9]')">
                                        <subfield code="a">
                                            <xsl:value-of
                                                select="concat(ead/archdesc/did/physdesc/extent[1],' ',ead/archdesc/did/physdesc/extent[1]/@unit,' (',ead/archdesc/did/physdesc/extent[2],' ',ead/archdesc/did/physdesc/extent[2]/@unit,')')"
                                            />
                                        </subfield>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <subfield code="a">
                                            <xsl:value-of
                                                select="concat(ead/archdesc/did/physdesc/extent[1],' ',ead/archdesc/did/physdesc/extent[1]/@unit)"
                                            />
                                        </subfield>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </datafield>
                        </xsl:if>

                        <xsl:if test="ead/archdesc/scopecontent/p">
                            <datafield tag="520" ind2=" " ind1="2">
                                <subfield code="a">
                                    <xsl:value-of
                                        select="normalize-space(concat(ead/archdesc/scopecontent/head,': ',ead/archdesc/scopecontent/p[1],ead/archdesc/scopecontent/p[2]))"
                                    />
                                </subfield>
                            </datafield>
                        </xsl:if>

                        <xsl:variable name="genreForm" select="ead/archdesc/controlaccess/genreform"/>
                        <xsl:variable name="controlHead" select="ead/archdesc/controlaccess/head"/>
                        <xsl:variable name="gFno" select="(count($genreForm))"/>
                        <xsl:if test="exists($genreForm)">
                            <datafield tag="520" ind2=" " ind1="8">
                                <subfield code="a">
                                    <xsl:value-of
                                        select="$controlHead[following-sibling::genreform][1],''"/>
                                    <xsl:for-each select="$genreForm[position() &lt; $gFno]">
                                        <xsl:value-of select="concat(node(),', ')"/>
                                    </xsl:for-each>
                                    <xsl:value-of select="$genreForm[position() = $gFno]"/>
                                </subfield>

                            </datafield>
                        </xsl:if>

                        <xsl:variable name="archivistName"
                            select="ead/archdesc/did/origination/(persname,famname, name,corpname)"/>
                        <xsl:variable name="archivistNo" select="count($archivistName)"/>
                        <xsl:if test="not(empty($archivistName/node()))">
                            <xsl:for-each select="$archivistName[position() &lt;= $archivistNo]">
                                <datafield tag="545" ind2=" " ind1="0">
                                    <subfield code="a">
                                        <xsl:value-of
                                            select="normalize-space(node()[position() &lt;= $archivistNo])"
                                        />
                                    </subfield>
                                </datafield>
                            </xsl:for-each>
                        </xsl:if>

                        <xsl:variable name="subjectSAO"
                            select="ead/archdesc/controlaccess/subject[@source='sao']"/>
                        <xsl:for-each select="$subjectSAO[1]">
                            <datafield tag="650" ind2="7" ind1=" ">
                                <subfield code="a">
                                    <xsl:value-of select="$subjectSAO[1]"/>
                                </subfield>
                                <subfield code="2">sao</subfield>
                            </datafield>
                        </xsl:for-each>
                        <xsl:for-each select="$subjectSAO[2]">
                            <datafield tag="650" ind2="7" ind1=" ">
                                <subfield code="a">
                                    <xsl:value-of select="$subjectSAO[2]"/>
                                </subfield>
                                <subfield code="2">sao</subfield>
                            </datafield>
                        </xsl:for-each>
                        <xsl:for-each select="$subjectSAO[3]">
                            <datafield tag="650" ind2="7" ind1=" ">
                                <subfield code="a">
                                    <xsl:value-of select="$subjectSAO[3]"/>
                                </subfield>
                                <subfield code="2">sao</subfield>
                            </datafield>
                        </xsl:for-each>
                        <xsl:for-each select="$subjectSAO[4]">
                            <datafield tag="650" ind2="7" ind1=" ">
                                <subfield code="a">
                                    <xsl:value-of select="$subjectSAO[4]"/>
                                </subfield>
                                <subfield code="2">sao</subfield>
                            </datafield>
                        </xsl:for-each>

                        <datafield tag="856" ind2="2" ind1="4">
                            <subfield code="u"
                                    >http://www.ediffah.org/search/present.cgi?id=<xsl:value-of
                                    select="ead/eadheader/eadid/@identifier"/></subfield>

                            <subfield code="z">Beskrivning i Ediffah, katalog för arkiv och handskriftssamlingar.</subfield>

                        </datafield>



                    </record>

                    <record type="Holdings">


                        <leader>XXXXXnx  a22XXXXX1n 4500</leader>


                        <controlfield tag="008"><xsl:value-of select="$cFdate"
                            />||0000|||||001||||||000000</controlfield>


                        <datafield tag="852" ind2=" " ind1=" ">
                            <subfield code="b">S</subfield>                           
                                <subfield code="z">
                                    <xsl:value-of select="'HS-signum:',normalize-space(ead/eadheader/eadid)"/>
                                </subfield>                                          
                        </datafield>


                        <xsl:apply-templates select="@*|node()"/>
                    </record>
                </xsl:if>
            </xsl:variable>

            <xsl:apply-templates select="$unsorted/*"/>
        </collection>
    </xsl:template>

    <xsl:template match="record[@type='Bibliographic']">
        <record type="Bibliographic">

            <xsl:perform-sort select="*">
                <xsl:sort select="@tag"/>
                <xsl:sort select="@ind1"/>
                <xsl:sort select="@ind2"/>
            </xsl:perform-sort>
        </record>
    </xsl:template>

    <xsl:template match="record[@type='Holdings']">
        <record type="Holdings">

            <xsl:perform-sort select="*">
                <xsl:sort select="@tag"/>
                <xsl:sort select="@ind1"/>
                <xsl:sort select="@ind2"/>
            </xsl:perform-sort>
        </record>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

</xsl:stylesheet>
