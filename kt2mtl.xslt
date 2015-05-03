<xslt:stylesheet xmlns:xslt="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xslt:output method="text" indent="no"/>


<xslt:template match="/" >

	<xslt:apply-templates select="/Root/Object/Object[@Type='Model']"/>

</xslt:template>



<xslt:template match="/Root/Object/Object[@Type='Model']">

	<xslt:call-template name="comments" />

	<xslt:text>newmtl </xslt:text><xslt:value-of select="@Name"/><xslt:text>
</xslt:text>

	<xslt:apply-templates select=".//Object[@Type='Material']/Object[@Type='Texture']/Parameter[@Name='Color' and @Type='RGB']"/>
	<xslt:apply-templates select=".//Object[@Type='Material']//Object[@Type='Texture']/Parameter[@Name='Filename']"/>
	<xslt:apply-templates select="Object[@Type='Material']/Parameter"/>

<xslt:text>

</xslt:text>
</xslt:template>


<xslt:template name="comments" >
	<xslt:for-each select="@*">
		<xslt:text># </xslt:text><xslt:value-of select="name()"/><xslt:text>=</xslt:text>
		<xslt:value-of select="."/><xslt:text>
</xslt:text>
	</xslt:for-each>
</xslt:template>

<xslt:template match="//Object[@Type='Model']/Object[@Type='Material']/Parameter[@Name='Shininess']">
	<xslt:text>Ns </xslt:text><xslt:value-of select="@Value"/><xslt:text>
</xslt:text>
</xslt:template> 

<xslt:template match="//Object[@Type='Model']/Object[@Type='Material']/Parameter[@Name='Index of Refraction']">
	<xslt:text>Ni </xslt:text><xslt:value-of select="@Value"/><xslt:text>
</xslt:text>
</xslt:template> 


<xslt:template match="//Object[@Type='Model']/Object[@Type='Material']/Object[@Type='Texture']/Parameter[@Name='Color' and @Type='RGB']">
	<xslt:choose>
		<xslt:when test="matches(../@Identifier,'/Diffuse/')">
			<xslt:text>Kd</xslt:text>
		</xslt:when>
		<xslt:when test="matches(../@Identifier,'/Ambient/')">
			<xslt:text>Ka</xslt:text>
		</xslt:when>
		<xslt:when test="matches(../@Identifier,'/Specular/')">
			<xslt:text>Ks</xslt:text>
		</xslt:when>
		<xslt:otherwise>
			<xslt:text># not handled: </xslt:text><xslt:value-of select="../@Identifier"/>
			<xslt:text> = </xslt:text>
		</xslt:otherwise>
	</xslt:choose>

	<xslt:for-each select="tokenize(@Value,'\s+')">
		<xslt:text> </xslt:text><xslt:value-of select="."/>
	</xslt:for-each>
	<xslt:text>
</xslt:text>
</xslt:template> 

<xslt:template match="//Object[@Type='Model']/Object[@Type='Material']//Object[@Type='Texture']/Parameter[@Name='Filename']">
	<xslt:choose>
		<xslt:when test="matches(../@Identifier,'/Diffuse/')">
			<xslt:text>map_Kd </xslt:text>
		</xslt:when>
		<xslt:when test="matches(../@Identifier,'/Ambient/')">
			<xslt:text>map_Ka </xslt:text>
		</xslt:when>
		<xslt:when test="matches(../@Identifier,'/Specular/')">
			<xslt:text>map_Ks </xslt:text>
		</xslt:when>
		<xslt:when test="matches(../../@Identifier,'/Diffuse/')">
			<xslt:text>map_Kd </xslt:text>
		</xslt:when>
		<xslt:when test="matches(../../@Identifier,'/Ambient/')">
			<xslt:text>map_Ka </xslt:text>
		</xslt:when>
		<xslt:when test="matches(../../@Identifier,'/Specular/')">
			<xslt:text>map_Ks </xslt:text>
		</xslt:when>
		<xslt:otherwise>
			<xslt:text># not handled: </xslt:text><xslt:value-of select="../@Identifier"/>
			<xslt:text> = </xslt:text>
		</xslt:otherwise>
	</xslt:choose>

	<xslt:value-of select="@Value"/><xslt:text>
</xslt:text>
</xslt:template> 
 
 
</xslt:stylesheet> 