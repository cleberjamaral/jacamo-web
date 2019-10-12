<?xml version="1.0" encoding="ISO-8859-1" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--
    TODO: Implement show/hide agent's properties on fullstack pure JS version
    Here it is allways true
  -->
    <xsl:param name="show-annots"  select="'true'" />

    <xsl:output method="html" />
    <xsl:strip-space elements="*" />

    <xsl:template match="agent">
        <html>
                <xsl:apply-templates select="beliefs" />
                <xsl:apply-templates select="circumstance/mailbox" />
                <xsl:apply-templates select="circumstance/events" />
                <xsl:apply-templates select="circumstance/options" />
                <xsl:apply-templates select="circumstance/intentions" />
                <xsl:apply-templates select="circumstance/actions" />
                <xsl:apply-templates select="plans" />
        </html>
    </xsl:template>

    <xsl:template match="beliefs">
        <xsl:if test="count(literal) > 0" >
            <details><summary>Beliefs</summary>
            <xsl:for-each select="namespaces/namespace">
                    <div class="namespace">
                    <details><summary><xsl:value-of select="@id" /></summary>

                    <xsl:variable name="nsId" select="@id" />
                    <xsl:for-each select="../../literal[@namespace=$nsId]">
                        <!-- xsl:sort select="structure/@functor" / -->
                        <!-- >xsl:if test="@namespace != 'default' and position()=1">
                             <br/><b><xsl:value-of select="@namespace" /><xsl:text>::</xsl:text></b> <br/>
                        </xsl:if -->
                        <span class="belief">
                            <xsl:apply-templates select="." />
                        </span>
                        <span class="punctuation">.</span>
                        <br/>
                    </xsl:for-each>
                    </details>
                    </div>
            </xsl:for-each>
            <br/>

            <!-- TODO: Implement show/hide agent's properties on fullstack pure JS version
            <xsl:variable name="agentname" select="/agent/@name"/>
            <div align="right">
            <xsl:if test="$show-annots='true'">
            	<a href='/agents/{$agentname}/hide?annots'>hide annotations</a>
            </xsl:if>
            <xsl:if test="$show-annots='false'">
            	<a href='/agents/{$agentname}/show?annots'>show annotations</a>
            </xsl:if>
            </div>
          -->
            </details>
        </xsl:if>

        <!-- Rules -->
        <xsl:if test="count(rule) > 0" >
            <details><summary>Rules</summary>
                <div class="rules">
                        <xsl:for-each select="rule">
                                    <span class="rule">
                                        <xsl:apply-templates select="." />
                                    </span>
                        </xsl:for-each>
                        <br/>
                </div>
           </details>
        </xsl:if>
    </xsl:template>

	<xsl:template match="plans">
		<xsl:if test="count(plan) > 0">
			<details>
				<summary>Plans</summary>
				<xsl:for-each
					select="plan[not(@file=preceding-sibling::plan/@file)]/@file">
					<xsl:choose>
						<xsl:when test="not(starts-with(., 'jar:'))">
							<div class="plans">
								<xsl:variable name="fId" select="."/>
                <xsl:variable name="separator" select="'.'"/>
                <xsl:variable name="agentname" select="/agent/@name"/>
								<details>
									<summary>
										<xsl:value-of select="." />
                    <!--Allows editing asl file only if it has the same name of the agent -->
                    <xsl:if test="normalize-space(substring-before($fId, $separator)) = $agentname">
										  &#160; <a href="./agent_editor.html#{$fId}">[edit]</a>
                    </xsl:if>
									</summary>
									<xsl:for-each select="../../plan[@file=$fId]">
										<div class="plan">
											<xsl:apply-templates select="." />
										</div>
									</xsl:for-each>
								</details>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="plans">
								<details>
									<summary>
										<xsl:value-of select="." />
									</summary>
									<xsl:variable name="fId" select="." />
									<xsl:for-each select="../../plan[@file=$fId]">
										<div class="plan">
											<xsl:apply-templates select="." />
										</div>
									</xsl:for-each>
								</details>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:for-each select="plan[not(@file)]">
					<div class="plan">
						<xsl:apply-templates select="." />
					</div>
				</xsl:for-each>
			</details>
		</xsl:if>
	</xsl:template>


    <xsl:template match="mailbox">
        <xsl:if test="count(message) > 0" >
            <details><summary>MailBox</summary>
                <blockquote>
                    <xsl:for-each select="message">
                          <span class="message">
                              <xsl:apply-templates select="." />
                              <br/>
                          </span>
                    </xsl:for-each>
                    <br/>
                </blockquote>
            </details>
       </xsl:if>
    </xsl:template>


    <xsl:template match="events">
        <xsl:if test="count(event) > 0" >
            <details><summary>Events</summary>
                <div class="events">
                    <table cellspacing="0" cellpadding="3">
                        <tr>
                            <th>Sel</th>
                            <th>Trigger</th>
                            <th>Intention</th>
                        </tr>
                        <xsl:apply-templates />
                    </table>
                </div>
            </details>
        </xsl:if>
    </xsl:template>

    <xsl:template match="event">
        <tr>
            <td>
                <xsl:if test="@selected='true'">
                    <b>X</b>
                </xsl:if>
                <xsl:value-of select="@pending" />
            </td>

            <td>
                <xsl:apply-templates />
            </td>
            <td>
                <xsl:value-of select="@intention" />
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="intentions">
        <xsl:if test="count(intention) > 0" >
            <details><summary>Intentions</summary>
                <div class="intentions">

                    <table cellspacing="0" cellpadding="5">
                        <tr>
                            <th>Sel</th>
                            <th>Id</th>
                            <th>Pen</th>
                            <th>Intended Means</th>
                        </tr>
                        <xsl:apply-templates />
                    </table>
                </div>
            </details>
        </xsl:if>
    </xsl:template>

    <xsl:template match="intention">
        <tr>
            <td>
                <xsl:if test="@selected='true'">
                    <b>X</b>
                </xsl:if>
            </td>

            <td>
                <xsl:value-of select="@id" />
            </td>

            <td>
                <xsl:if test="string-length(@pending) > 0">
                    <b><xsl:value-of select="@pending" /></b>
                </xsl:if>
                <xsl:if test="string-length(@suspended) > 0 and @suspended='true' and not(starts-with(@pending,'suspen'))">
                    <xsl:text> (suspended) </xsl:text>
                </xsl:if>
            </td>

            <td>
                <details><summary><xsl:value-of select="intended-means/@trigger" /></summary>
          	        <div class="plans">
                    <xsl:apply-templates />
                    </div>
                </details>
                <xsl:if test="@finished = 'true'">
                    <b> (finished)</b>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="intended-means">
	       	<xsl:apply-templates select="@trigger"/>
          	<xsl:apply-templates select="body"/>

            <div class="unifier">
                <xsl:apply-templates select="unifier"/>
            </div>
    </xsl:template>


    <xsl:template match="actions">
        <xsl:if test="count(action) > 0" >
            <details><summary>Actions</summary>
                <blockquote>

                <table cellspacing="0" cellpadding="3">
                    <tr>
                        <th>Pend</th>
                        <th>Feed</th>
                        <th>Sel</th>
                        <th>Term</th>
                        <th>Result</th>
                        <th>Intention</th>
                    </tr>
                    <xsl:apply-templates select="action"/>
                </table>
                </blockquote>
            </details>
        </xsl:if>
    </xsl:template>

    <xsl:template match="action">
        <tr>
            <td>
                <xsl:if test="@pending='true'">
                    X
                </xsl:if>
            </td>

            <td>
                <xsl:if test="@feedback='true'">
                    X
                </xsl:if>
            </td>

            <td>
                <xsl:if test="@selected='true'">
                    <b>X</b>
                </xsl:if>
            </td>

            <td>
                <xsl:value-of select="@term" />
            </td>
            <td>
                <xsl:value-of select="@result" />
            </td>
            <td>
                <xsl:value-of select="@intention" />
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="options">
        <xsl:if test="count(option) > 0" >
            <details><summary>Options</summary>
                <blockquote>

                    <table cellspacing="0" cellpadding="3">
                        <tr>
                            <th>App</th>
                            <th>Sel</th>
                            <th>Plan</th>
                            <th>Unifier</th>
                        </tr>
                        <xsl:apply-templates />
                    </table>
                </blockquote>
          </details>
      </xsl:if>
    </xsl:template>

    <xsl:template match="option">
        <tr>
            <td>
                <xsl:if test="@applicable='true'">
                    X
                </xsl:if>
            </td>

            <td>
                <xsl:if test="@selected='true'">
                    <b>X</b>
                </xsl:if>
            </td>

            <td>
                <xsl:apply-templates select="plan/trigger"/>
            </td>
            <td>
                <xsl:apply-templates select="unifier"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="unifier">
        <xsl:if test="count(map) > 0">
            {
            <xsl:for-each select="map">
                <xsl:apply-templates select="var-term"/>
                =
                <xsl:apply-templates select="value"/>
                <xsl:if test="not(position()=last())">, </xsl:if>
            </xsl:for-each>
            }
        </xsl:if>
    </xsl:template>

    <xsl:template match="plan">
    	<!-- xsl:if test="not(starts-with(label/literal/structure/@functor,'kqml'))" -->

        <xsl:if test="count(label) > 0 and not(starts-with(label/literal/structure/@functor,'l__'))">
            <span class="plan-label">
                @<xsl:apply-templates select="label" />
            </span>
        </xsl:if>

        <span class	="trigger">
            <xsl:apply-templates select="trigger" />
        </span>

        <xsl:if test="count(context) > 0">
                    <!--span class="operator"> : </span-->
                    <xsl:apply-templates select="context" />
        </xsl:if>

        <xsl:if test="count(body/body-literal) > 0">
                    <!-- span class="operator"> &lt;- </span -->
                    <xsl:apply-templates select="body">
                         <xsl:with-param name="in-plan" select="'true'" />
                    </xsl:apply-templates>
        </xsl:if>
        <!-- /xsl:if -->
    </xsl:template>


    <xsl:template match="context">
        <div class="context">
            <xsl:apply-templates />
        </div>
    </xsl:template>

    <xsl:template match="expression">
        <span class="punctuation">(</span>
        <xsl:apply-templates select="left" />
        <span class="operator">
            <xsl:value-of select="@operator" />
        </span>
        <xsl:apply-templates select="right" />
        <span class="punctuation">)</span>
    </xsl:template>

    <xsl:template match="body">
        <xsl:param name="in-plan" select="'false'" />
        <div class="body">
        <xsl:for-each select="body-literal">
            <xsl:choose>
                <xsl:when test="literal/@ia = 'true'">
                    <span class="internal-action"><xsl:apply-templates />	</span>
                </xsl:when>
                <xsl:when test="string-length(@type) = 0">
                    <span class="action"><xsl:apply-templates />	</span>
                </xsl:when>
                <xsl:when test="@type = '?'">
                    <span class="test">?<xsl:apply-templates />	</span>
                </xsl:when>
                <xsl:when test="@type = '!' or @type = '!!'">
                    <span class="achieve"><xsl:value-of select="@type"/><xsl:apply-templates />	</span>
                </xsl:when>
                <xsl:when test="@type = '+' or @type = '-' or @type = '++' or @type = '--'">
                    <span class="operator"><xsl:value-of select="@type"/> </span>
                    <span class="belief"><xsl:apply-templates />	</span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/><xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="not(position()=last())"> <span class="punctuation">;</span> <br/> </xsl:if>
        </xsl:for-each>
        <span class="punctuation">.</span>
        </div>
    </xsl:template>


    <xsl:template match="trigger">
        <xsl:value-of select="@operator"/>
        <xsl:value-of select="@type"/>
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="rule">
        <xsl:apply-templates select="head"/>
        <!--  span class="operator"> :- </span -->
        <xsl:apply-templates select="context" />
        <!-- span class="punctuation">.</span -->
    </xsl:template>

    <xsl:template match="literal">
        <xsl:if test="@negated = 'true'">
            <b><xsl:text>~</xsl:text></b>
        </xsl:if>
        <xsl:if test="count(@cyclic-var) > 0">
            <b><xsl:text>...</xsl:text></b>
        </xsl:if>
        <xsl:apply-templates  />
    </xsl:template>

    <xsl:template match="structure">
        <xsl:value-of select="@functor"/>
        <xsl:if test="count(arguments) > 0">
            <span class="punctuation">(</span>
            <xsl:for-each select="arguments/*">
                <xsl:apply-templates select="." />
                <xsl:if test="not(position()=last())"><span class="punctuation">,</span></xsl:if>
            </xsl:for-each>
            <span class="punctuation">)</span>
        </xsl:if>
        <xsl:if test="count(annotations) > 0">
            <xsl:apply-templates select="annotations" />
        </xsl:if>
    </xsl:template>

    <xsl:template match="annotations">
        <xsl:if test="$show-annots='true'">
            <span class="annotations">
                <sub>
                    <xsl:apply-templates />
                </sub>
            </span>
        </xsl:if>
        <xsl:if test="$show-annots='false'">
            <xsl:if test="count(list-term) > 0">
                <sub>
                    <span style="color: rgb(0 ,0, 200)">
                    <a href="show?annots" style="text-decoration: none">
                    <xsl:text>[...]</xsl:text>
                    </a>
                    </span>
                </sub>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="var-term">
        <span class="var-term">
            <xsl:value-of select="@functor"/>
            <xsl:if test="count(annotations) > 0">
                <xsl:apply-templates select="annotations" />
            </xsl:if>
        </span>
    </xsl:template>

    <xsl:template match="number-term">
        <span class="number-term"><xsl:value-of select="text()"/></span>
    </xsl:template>
    <xsl:template match="string-term">
        <span class="string-term"><xsl:value-of select="text()"/></span>
    </xsl:template>
    <xsl:template match="list-term">
        <span class="punctuation">[</span>
        <xsl:for-each select="*">
            <span class="punctuation"><xsl:value-of select="@sep"/></span>
            <xsl:apply-templates select="." />
        </xsl:for-each>
        <span class="punctuation">]</span>
    </xsl:template>

</xsl:stylesheet>
