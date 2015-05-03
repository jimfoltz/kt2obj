<!-- KT2OBJ v1.0.1
Version history:

	KT2OBJ v1.0.1
		When no Vertex List is provided, the number of vertices is 0
		When no Normal List is provided, the number of normals is 0
		When no Map Channel i provided, the number of UVmap is 0
	
	KT2OBJ v1.0
		Initial release
-->

<xslt:stylesheet xmlns:xslt="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xslt:output method="text" indent="no"/>


<xslt:template match="/" >

	<xslt:call-template name="DealWithSurfaceList">
		<xslt:with-param name="List" select="'Vertex List'"/>
		<xslt:with-param name="name" select="'v'"/>
	</xslt:call-template>
	
	<xslt:call-template name="DealWithSurfaceList">
		<xslt:with-param name="List" select="'Normal List'"/>
		<xslt:with-param name="name" select="'vn'"/>
	</xslt:call-template>	

	<xslt:call-template name="DealWithUVList"/>
	
	<xslt:apply-templates select="/Root/Object/Object[@Type='Model'][1]">
		<xslt:with-param name="nbv" select="1" />
		<xslt:with-param name="nbvn" select="1" />
		<xslt:with-param name="nbvt" select="1" />
		<xslt:with-param name="pos" select="1" />
	</xslt:apply-templates>

</xslt:template>


<xslt:template name="DealWithSurfaceList">
<xslt:param name="List" />
<xslt:param name="name" />

	<xslt:call-template name="DisplayListType">
		<xslt:with-param name="List" select="$List"/>
	</xslt:call-template>

	<xslt:for-each select="/Root/Object/Object[@Type='Model']">
		<xslt:call-template name="comments" />
		<xslt:apply-templates select="Object[@Type='Surface']/Parameter[@Name=$List]/P">
			<xslt:with-param name="name" select="$name"/>
		</xslt:apply-templates>
		<xslt:text>
</xslt:text>
	</xslt:for-each>

	<xslt:call-template name="DisplayListType">
		<xslt:with-param name="List" select="concat('End of ',$List)"/>
	</xslt:call-template>

	<xslt:text>
</xslt:text>

</xslt:template>

<xslt:template name="DealWithUVList">

	<xslt:call-template name="DisplayListType">
		<xslt:with-param name="List" select="'UV List'"/>
	</xslt:call-template>

	<xslt:for-each select="/Root/Object/Object[@Type='Model']">
		<xslt:call-template name="comments" />
		<xslt:apply-templates select="Parameter[@Name='Map Channel' and @Type='Point2D List']/P">
			<xslt:with-param name="name" select="'vt'"/>
		</xslt:apply-templates>

		<xslt:text>
</xslt:text>
	</xslt:for-each>

	<xslt:call-template name="DisplayListType">
		<xslt:with-param name="List" select="'End of UV List'"/>
	</xslt:call-template>

	<xslt:text>
</xslt:text>

</xslt:template>


<xslt:template name="DisplayListType">
<xslt:param name="List" />

	<xslt:text>#######################################
</xslt:text>
	<xslt:text># </xslt:text>
	<xslt:value-of select="$List"/><xslt:text>
</xslt:text>
	<xslt:text>#######################################

</xslt:text>

</xslt:template>


<xslt:template match="/Root/Object/Object[@Type='Model']">
<xslt:param name="nbv" />
<xslt:param name="nbvn" />
<xslt:param name="nbvt" />
<xslt:param name="pos" />


	<xslt:call-template name="comments" />	

	<xslt:text>g </xslt:text><xslt:value-of select="@Name"/><xslt:text>
</xslt:text>

	<xslt:text>usemtl </xslt:text><xslt:value-of select="@Name"/><xslt:text>
</xslt:text>


	<xslt:variable name="nVValue" select="if (exists(Object[@Type='Surface']/Parameter[@Name='Vertex List']/@Value)) then Object[@Type='Surface']/Parameter[@Name='Vertex List']/@Value else 0" />

	<xslt:text># nbv = </xslt:text>
	<xslt:value-of select="$nbv"/><xslt:text>-</xslt:text><xslt:value-of select="$nbv + $nVValue - 1"/><xslt:text>
</xslt:text>

	<xslt:variable name="nVNValue" select="if (exists(Object[@Type='Surface']/Parameter[@Name='Normal List']/@Value)) then Object[@Type='Surface']/Parameter[@Name='Normal List']/@Value else 0" />
		
	<xslt:text># nbvn = </xslt:text>
	<xslt:value-of select="$nbvn"/><xslt:text>-</xslt:text><xslt:value-of select="$nbvn + $nVNValue - 1"/><xslt:text>
</xslt:text>


	<xslt:variable name="nVTValue" select="if (exists(Parameter[@Name='Map Channel']/@Value)) then Parameter[@Name='Map Channel']/@Value else 0" />

	<xslt:text># nbvt = </xslt:text>
	<xslt:value-of select="$nbvt"/><xslt:text>-</xslt:text><xslt:value-of select="$nbvt + $nVTValue - 1"/><xslt:text>
</xslt:text>


	<xslt:for-each select="Object[@Type='Surface']/Parameter[@Name='Index List' and @Type='Triangle Index List']/F">
		<xslt:call-template name="f">
			<xslt:with-param name="nbv" select="$nbv"/>
			<xslt:with-param name="nbvn" select="$nbvn"/>
			<xslt:with-param name="nbvt" select="$nbvt"/>
		</xslt:call-template>
	</xslt:for-each>

	<xslt:apply-templates select="/Root/Object/Object[@Type='Model'][$pos + 1]">
		<xslt:with-param name="nbv" select="$nbv + $nVValue"/>
		<xslt:with-param name="nbvn" select="$nbvn + $nVNValue"/>
		<xslt:with-param name="nbvt" select="$nbvt + $nVTValue"/>
		<xslt:with-param name="pos" select="$pos + 1"/>
	</xslt:apply-templates>

</xslt:template>


<xslt:template name="comments" >
	<xslt:for-each select="@*">
		<xslt:text># </xslt:text><xslt:value-of select="name()"/><xslt:text>=</xslt:text>
		<xslt:value-of select="."/><xslt:text>
</xslt:text>
	</xslt:for-each>
</xslt:template>


<xslt:template name="f">
<xslt:param name="nbv" />
<xslt:param name="nbvn" />
<xslt:param name="nbvt" />

<xslt:variable name="buv" select="../../../Parameter[@Name='Map Channel' and @Type='Point2D List']/@Value &gt; 0"/>
<xslt:variable name="bvn" select="../../Parameter[@Name='Normal List']/@Value &gt; 0"/>

<xslt:variable name="poffset" select="(position() - 1)*3"/>

<xslt:variable name="bkuv" select="../../../Parameter[@Name='Map Channel' and @Type='Point2D List']/@Value=3*../@Value"/>
<xslt:variable name="bkvn" select="../../Parameter[@Name='Normal List']/@Value=3*../@Value"/>


<xslt:for-each select="@*">
	<xslt:text>f </xslt:text>
		<xslt:for-each select="tokenize(.,'\s+')">
			<xslt:value-of select="number(.) + $nbv"/>
			<xslt:if test="$buv or $bvn">
				<xslt:text>/</xslt:text>
			</xslt:if>
			<xslt:if test="$buv">
				<xslt:choose>
					<xslt:when test="$bkuv">
						<xslt:value-of select="$poffset + position() + $nbvt - 1"/>
					</xslt:when>
					<xslt:otherwise>
						<xslt:value-of select="number(.) + $nbvt"/>
					</xslt:otherwise>
				</xslt:choose>
			</xslt:if>
			<xslt:if test="$bvn">
				<xslt:text>/</xslt:text>
				<xslt:choose>
					<xslt:when test="$bkvn">
						<xslt:value-of select="$poffset + position() + $nbvn - 1"/>
					</xslt:when>
					<xslt:otherwise>
						<xslt:value-of select="number(.) + $nbvn"/>
					</xslt:otherwise>
				</xslt:choose>
			</xslt:if>
			<xslt:text> </xslt:text>
		</xslt:for-each>
	<xslt:text>
</xslt:text>
</xslt:for-each>
</xslt:template> 

<xslt:template match="/Root/Object/Object[@Type='Model']/Object[@Type='Surface']/Parameter/P">
<xslt:param name="name" />

<xslt:for-each select="@*">
	<xslt:value-of select="$name"/>
	<xslt:text> </xslt:text>
 	<xslt:value-of select="."/><xslt:text>
</xslt:text>
</xslt:for-each>
</xslt:template> 


<xslt:template match="/Root/Object/Object[@Type='Model']/Parameter/P">
<xslt:param name="name" />

<xslt:for-each select="@*">
	<xslt:value-of select="$name"/><xslt:text> </xslt:text>
	<xslt:for-each select="tokenize(.,'\s+')">
			<xslt:choose>
				<xslt:when test="position() = 2">
					<xslt:value-of select="-number(.)"/>
				</xslt:when>
				<xslt:otherwise>
					<xslt:value-of select="number(.)"/>
				</xslt:otherwise>
			</xslt:choose>
			<xslt:text> </xslt:text>
	</xslt:for-each>
 	<xslt:text>
</xslt:text>
</xslt:for-each>
</xslt:template> 

 
</xslt:stylesheet> 