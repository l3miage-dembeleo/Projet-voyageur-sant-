<?xml version="1.0" encoding="UTF-8"?><!--Prototype du fichier xml-->

<!--
    Document   : cabinet.xsl
    Created on : 15 novembre 2022, 15:56
    Author     : dembeleo
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cab='http://univ-grenoble-alpes.fr/Dembele/Cabinet'
                xmlns:act='http://univ-grenoble-alpes.fr/Dembele/Actes' version="1.0">
                <!--Définition et préfixage du vocabulaire xslt, du vocabulaire de cabinet.xml
                et du vocabulaire de actes.xml-->
    <!-- Définition du paramètre destinedId prenant comme valeur l'id d'un infirmier -->           
    <xsl:param name="destinedId" select="001"/>
    <!-- Définition de la variable visitesDuJour prenant comme valeur le noeud visite dont
    l'attribut intervenant est identique au paramètre destinedId --> 
    <!--REMPLACER ACT PAR CAB VOIR--> 
    <xsl:variable name="visitesDuJour" select="//act:visite[@intervenant=$destinedId]"/>
    <!-- récupération de tous les noeuds du fichier actes.xml dans la variable actes-->
    <xsl:variable name="actes" select="document('../xml/actes.xml', /)/act:ngap"/>
    <xsl:output method="html"/><!--Définition du format du document de sortie en html--> 
    <xsl:template match="/"> <!--On se place à la racine du document xml--> 
        <html>
            <head> <!--Tete du fichier html-->
            <!--Code javascript permettant le fonctionnement du bouton FACTURE -->
                <script type="text/javascript"> 
                    function openFacture(prenom, nom, actes) {
                    var width  = 500;
                    var height = 300;
                    if(window.innerWidth) {
                        var left = (window.innerWidth-width)/2;
                        var top = (window.innerHeight-height)/2;
                    }
                    else {
                        var left = (document.body.clientWidth-width)/2;
                        var top = (document.body.clientHeight-height)/2;
                    }
                    var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
                    factureText = "Facture pour : " + prenom + " " + nom;
                    factureWindow.document.write(factureText);
                    }

                </script>
                <!--Le titre du document html serait Visite--> 
                <title>Visite</title>
            </head>
            <body> <!--Corps du fichier html, c'est ce qui apparaitra dans le document html-->
                <!-- récupération et affichage du nom et du prénom de l'intervenant -->
                <p>Bonjour <xsl:value-of select="//cab:infirmier[@id=$destinedId]/cab:prenom"/>,<br/>
                    <!-- comptage et affichage du nombre de visites de l'intervenant -->
                    Aujourd'hui, vous avez <xsl:value-of select="count(//cab:patients/cab:patient[cab:visite[@intervenant=$destinedId]])"/> patient(s)
                </p>
                <!--- affichage des visites de l'intervenant en faisant appel au template patient -->
                <xsl:apply-templates select="//cab:patient[cab:visite[@intervenant=$destinedId]]"/>
            </body>
        </html>
    </xsl:template>

    <!--- template patient -->
    <xsl:template match="cab:patient">
        <address>
            <!-- récupération du nom du patient -->
            <xsl:value-of select="cab:nom"/>
            <br/>

            <!-- récupération et affichage du numero, de la rue, du code postal et de la 
            ville de chaque patient ayant fait une visite-->
            <xsl:value-of select="concat(cab:adresse/cab:numero,' ')"/>
            <xsl:value-of select="concat(cab:adresse/cab:rue,' ')"/>
            <xsl:value-of select="concat(cab:adresse/cab:codePostal,' ')"/>
            <xsl:value-of select="cab:adresse/cab:ville"/>
            <br/>
        </address>
        <!-- affichage des actes du patient en faisant appel au template acte.
            Pour se faire depuis le fichiers cabinet.xml on récupère les id des actes du patient dans une variable ide que
            nous utilisons ensuite pour récupérer les actes dans le fichier actes.xml-->
        <xsl:variable name="ide" select="cab:visite/cab:acte/@id"/>
        <xsl:apply-templates select="actes/act:actes/act:acte[@id=$ide]"/>
        <!-- affichage du nom et prénom du patient -->
        <button>
            <!--appel au xslt pour afficher le formulaire de facture dans un boutton
             nommé FACTURE!-->
            <xsl:attribute name="onclick">
                openFacture('<xsl:value-of select="cab:prenom"/>', 
                '<xsl:value-of select="cab:nom"/>',
                '<xsl:value-of select="actes/act:actes/act:acte[@id=$ide]"/>')
            </xsl:attribute>
            FACTURE !
        </button>
    </xsl:template>
    <!--- template acte -->
    <xsl:template match="act:acte">
        <p>
            <xsl:value-of select="text()"/><!---selection et affichage du text contenu dans chaque acte trouvé-->
        </p>
    </xsl:template>
    
</xsl:stylesheet>
