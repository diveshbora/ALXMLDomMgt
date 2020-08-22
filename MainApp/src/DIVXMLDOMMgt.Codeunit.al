codeunit 50100 "DIV XML DOM Mgt."
{
    trigger OnRun();
    begin
    end;

    procedure AddElement(var pXmlNode: XmlNode; pNodeName: Text; pNodeText: Text; pNameSpace: Text; var pCreatedNode: XmlNode): Boolean
    var
        lNewChildNode: XmlNode;
    begin
        if pNodeText <> '' then
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace, pNodeText).AsXmlNode()
        else
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace).AsXmlNode();
        if pXmlNode.AsXmlElement().Add(lNewChildNode) then begin
            pCreatedNode := lNewChildNode;
            exit(true);
        end;
    end;

    procedure AddRootElement(var pXMLDocument: XmlDocument; pNodeName: Text; var pCreatedNode: XmlNode): Boolean
    begin
        pCreatedNode := XmlElement.Create(pNodeName).AsXmlNode();
        exit(pXMLDocument.Add(pCreatedNode));
    end;

    procedure AddRootElementWithPrefix(var pXMLDocument: XmlDocument; pNodeName: Text; pPrefix: Text; pNameSpace: Text; var pCreatedNode: XmlNode): Boolean
    begin
        pCreatedNode := XmlElement.Create(pNodeName, pNameSpace).AsXmlNode();
        pCreatedNode.AsXmlElement().Add(XmlAttribute.CreateNamespaceDeclaration(pPrefix, pNameSpace));
        exit(pXMLDocument.Add(pCreatedNode));
    end;

    procedure AddElementWithPrefix(var pXmlNode: XmlNode; pNodeName: Text; pNodeText: Text; pPrefix: Text; pNameSpace: Text; var pCreatedNode: XmlNode): Boolean
    var
        lNewChildNode: XmlNode;
    begin
        if pNodeText <> '' then
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace, pNodeText).AsXmlNode()
        else
            lNewChildNode := XmlElement.Create(pNodeName, pNameSpace).AsXmlNode();
        lNewChildNode.AsXmlElement().Add(XmlAttribute.CreateNamespaceDeclaration(pPrefix, pNameSpace));
        if pXmlNode.AsXmlElement().Add(lNewChildNode) then begin
            pCreatedNode := lNewChildNode;
            exit(true);
        end;
    end;

    procedure AddPrefix(var pXmlNode: XmlNode; pPrefix: Text; pNameSpace: Text): Boolean
    begin
        pXmlNode.AsXmlElement().Add(XmlAttribute.CreateNamespaceDeclaration(pPrefix, pNameSpace));
        exit(true);
    end;

    procedure AddAttribute(var pXmlNode: XmlNode; pName: Text; pValue: Text): Boolean
    begin
        pXmlNode.AsXmlElement().SetAttribute(pName, pValue);
        exit(true);
    end;

    procedure AddAttributeWithNamespace(var pXmlNode: XmlNode; pName: Text; pNameSpace: Text; pValue: Text): Boolean
    begin
        pXmlNode.AsXmlElement().SetAttribute(pName, pNameSpace, pValue);
        exit(true);
    end;

    procedure FindNode(pXMLRootNode: XmlNode; pNodePath: Text; var pFoundXmlNode: XmlNode): Boolean
    begin
        exit(pXMLRootNode.SelectSingleNode(pNodePath, pFoundXmlNode));
    end;

    procedure FindNodeWithNameSpace(pXMLRootNode: XmlNode; pNodePath: Text; pPrefix: Text; pNamespace: Text; var pFoundXmlNode: XmlNode): Boolean
    var
        lXmlNsMgr: XmlNamespaceManager;
        lXMLDocument: XmlDocument;
    begin

        if pXMLRootNode.IsXmlDocument() then
            lXmlNsMgr.NameTable(pXMLRootNode.AsXmlDocument().NameTable())
        else begin
            pXMLRootNode.GetDocument(lXMLDocument);
            lXmlNsMgr.NameTable(lXMLDocument.NameTable());
        end;
        lXMLNsMgr.AddNamespace(pPrefix, pNamespace);
        exit(pXMLRootNode.SelectSingleNode(pNodePath, lXmlNsMgr, pFoundXmlNode));
    end;

    procedure FindNodesWithNameSpace(pXMLRootNode: XmlNode; pXPath: Text; pPrefix: Text; pNamespace: Text; var pFoundXmlNodeList: XmlNodeList): Boolean
    var
        lXmlNsMgr: XmlNamespaceManager;
        lXMLDocument: XmlDocument;
    begin
        if pXMLRootNode.IsXmlDocument() then
            lXmlNsMgr.NameTable(pXMLRootNode.AsXmlDocument().NameTable())
        else begin
            pXMLRootNode.GetDocument(lXMLDocument);
            lXmlNsMgr.NameTable(lXMLDocument.NameTable());
        end;
        lXMLNsMgr.AddNamespace(pPrefix, pNamespace);
        exit(FindNodesWithNamespaceManager(pXMLRootNode, pXPath, lXmlNsMgr, pFoundXmlNodeList));
    end;

    procedure FindNodesWithNamespaceManager(pXMLRootNode: XmlNode; pXPath: Text; pXmlNsMgr: XmlNamespaceManager; var pFoundXmlNodeList: XmlNodeList): Boolean
    begin
        if not pXMLRootNode.SelectNodes(pXPath, pXmlNsMgr, pFoundXmlNodeList) then
            exit(false);
        if pFoundXmlNodeList.Count() = 0 then
            exit(false);
        exit(true);
    end;

    procedure FindNodeXML(pXMLRootNode: XmlNode; pNodePath: Text): Text
    var
        lFoundXmlNode: XmlNode;
    begin
        if pXMLRootNode.SelectSingleNode(pNodePath, lFoundXmlNode) then
            exit(lFoundXmlNode.AsXmlElement().InnerXml());
    end;

    procedure FindNodeText(pXMLRootNode: XmlNode; pNodePath: Text): Text
    var
        lFoundXmlNode: XmlNode;
    begin
        if pXMLRootNode.SelectSingleNode(pNodePath, lFoundXmlNode) then
            exit(lFoundXmlNode.AsXmlElement().InnerText());
    end;

    procedure FindNodeTextWithNameSpace(pXMLRootNode: XmlNode; pNodePath: Text; pPrefix: Text; pNamespace: Text): Text
    var
        lXmlNsMgr: XmlNamespaceManager;
        lXMLDocument: XmlDocument;
    begin

        if pXMLRootNode.IsXmlDocument() then
            lXmlNsMgr.NameTable(pXMLRootNode.AsXmlDocument().NameTable())
        else begin
            pXMLRootNode.GetDocument(lXMLDocument);
            lXmlNsMgr.NameTable(lXMLDocument.NameTable());
        end;
        lXMLNsMgr.AddNamespace(pPrefix, pNamespace);
        exit(FindNodeTextNs(pXMLRootNode, pNodePath, lXmlNsMgr));
    end;

    procedure FindNodeTextNs(pXMLRootNode: XmlNode; pNodePath: Text; pXmlNsMgr: XmlNamespaceManager): Text
    var
        lFoundXmlNode: XmlNode;
    begin
        if pXMLRootNode.SelectSingleNode(pNodePath, pXmlNsMgr, lFoundXmlNode) then
            exit(lFoundXmlNode.AsXmlElement().InnerText());
    end;

    procedure FindNodes(pXMLRootNode: XmlNode; pNodePath: Text; var pFoundXmlNodeList: XmlNodeList): Boolean
    begin
        if not pXMLRootNode.SelectNodes(pNodePath, pFoundXmlNodeList) then
            exit(false);
        if pFoundXmlNodeList.Count() = 0 then
            exit(false);
        exit(true);
    end;

    procedure GetRootNode(pXMLDocument: XmlDocument; var pFoundXmlNode: XmlNode): Boolean
    var
        lXmlElement: XmlElement;
    begin
        pXMLDocument.GetRoot(lXmlElement);
        pFoundXmlNode := lXmlElement.AsXmlNode();
    end;

    procedure FindAttribute(pXmlNode: XmlNode; var pXmlAttribute: XmlAttribute; pAttributeName: Text): Boolean
    begin
        exit(pXmlNode.AsXmlElement().Attributes().Get(pAttributeName, pXmlAttribute));
    end;

    procedure GetAttributeValue(pXmlNode: XmlNode; pAttributeName: Text): Text
    var
        lXmlAttribute: XmlAttribute;
    begin
        if pXmlNode.AsXmlElement().Attributes().Get(pAttributeName, lXmlAttribute) then
            exit(lXmlAttribute.Value());
    end;

    procedure AddDeclaration(var pXMLDocument: XmlDocument; pVersion: Text; pEncoding: Text; pStandalone: Text)
    var
        lXmlDeclaration: XmlDeclaration;
    begin
        lXmlDeclaration := XmlDeclaration.Create(pVersion, pEncoding, pStandalone);
        pXMLDocument.SetDeclaration(lXmlDeclaration);
    end;

    procedure AddGroupNode(var pXmlNode: XmlNode; pNodeName: Text)
    var
        lXMLNewChild: XmlNode;
    begin
        AddElement(pXmlNode, pNodeName, '', '', lXMLNewChild);
        pXmlNode := lXMLNewChild;
    end;

    procedure AddNode(var pXmlNode: XmlNode; pNodeName: Text; pNodeText: Text)
    var
        lXMLNewChild: XmlNode;
    begin
        AddElement(pXmlNode, pNodeName, pNodeText, '', lXMLNewChild);
    end;

    procedure AddLastNode(var pXmlNode: XmlNode; pNodeName: Text; pNodeText: Text)
    var
        lXMLNewChild: XmlNode;
        lXMLElement: XmlElement;
    begin
        AddElement(pXmlNode, pNodeName, pNodeText, '', lXMLNewChild);
        if pXmlNode.GetParent(lXMLElement) then
            pXmlNode := lXMLElement.AsXmlNode();
    end;

    procedure GetXmlNSMgr(pXMLRootNode: XmlNode; pPrefix: Text; pNamespace: Text; var pXmlNsMgr: XmlNamespaceManager): Text
    var
        lXMLDocument: XmlDocument;
    begin

        if pXMLRootNode.IsXmlDocument() then
            pXmlNsMgr.NameTable(pXMLRootNode.AsXmlDocument().NameTable())
        else begin
            pXMLRootNode.GetDocument(lXMLDocument);
            pXmlNsMgr.NameTable(lXMLDocument.NameTable());
        end;
        pXmlNsMgr.AddNamespace(pPrefix, pNamespace);
    end;

    procedure AddNameSpace(var pXmlNsMgr: XmlNamespaceManager; pPrefix: Text; pNamespace: Text);
    begin
        pXmlNsMgr.AddNamespace(pPrefix, pNamespace);
    end;

    procedure AddNamespaces(var pXmlNsMgr: XmlNamespaceManager; pXMLDocument: XmlDocument)
    var
        lXmlAttributeCollection: XmlAttributeCollection;
        lXmlAttribute: XmlAttribute;
        lXMLElement: XmlElement;
    begin
        pXmlNsMgr.NameTable(pXMLDocument.NameTable());
        pXMLDocument.GetRoot(lXMLElement);
        lXmlAttributeCollection := lXMLElement.Attributes();
        if lXMLElement.NamespaceUri() <> '' then
            pXmlNsMgr.AddNamespace('', lXMLElement.NamespaceUri());
        Foreach lXmlAttribute in lXmlAttributeCollection do
            if StrPos(lXmlAttribute.Name(), 'xmlns:') = 1 then
                pXmlNsMgr.AddNamespace(DELSTR(lXmlAttribute.Name(), 1, 6), lXmlAttribute.Value());
    end;

    procedure XMLEscape(pXMLText: Text): Text
    var
        lNewXmlNode: XmlNode;
    begin
        lNewXmlNode := XmlElement.Create('XMLEscape', '', pXMLText).AsXmlNode();
        exit(lNewXmlNode.AsXmlElement().InnerXml());
    end;

    procedure ReturnInnerTextFromXMLDocument(pXMLDocument: XmlDocument): Text
    var
        lXmlText: Text;
    begin
        pXMLDocument.WriteTo(lXmlText);
        exit(lXmlText);
    end;

    procedure FindNodeFromXMLDocumentRoot(pXMLDocument: XmlDocument; pNodepath: Text; var pFoundNode: XmlNode): Boolean
    var
        lRootNode: XmlNode;
    begin
        Clear(pFoundNode);
        lRootNode := pXMLDocument.AsXmlNode();
        if FindNode(lRootNode, pNodepath, pFoundNode) then
            exit(true);
    end;

    procedure GetSingleNodeFromNodeList(pXmlNodeList: XmlNodeList; pIndex: Integer; var pFoundNode: XmlNode): Boolean
    begin
        Clear(pFoundNode);
        if pXmlNodeList.Get(pIndex, pFoundNode) then
            exit(true);
    end;

    procedure FindNodeWithNamespaceManagerFromXMLDoc(pXMLDocument: XmlDocument; pXPath: Text; pXmlNsMgr: XmlNamespaceManager; var pFoundNode: XmlNode): Boolean
    var
        lRootNode: XmlNode;
    begin
        Clear(pFoundNode);
        GetRootNode(pXMLDocument, lRootNode);
        if lRootNode.SelectSingleNode(pXPath, pXmlNsMgr, pFoundNode) then
            exit(true);
    end;

    procedure FindNodeWithNamespaceManagerFromXmlNode(pRootNode: XmlNode; pXPath: Text; pXmlNsMgr: XmlNamespaceManager; var pFoundNode: XmlNode): Boolean
    begin
        if pRootNode.SelectSingleNode(pXPath, pXmlNsMgr, pFoundNode) then
            exit(true);
    end;

    procedure FindInnerTextFromXMLDocumentRootNode(pXMLDocument: XmlDocument; pNodepath: Text; var pInnerText: Text): Boolean
    var
        lRootNode: XmlNode;
        lFoundNode: XmlNode;
    begin
        Clear(pInnerText);
        GetRootNode(pXMLDocument, lRootNode);
        if FindNode(lRootNode, pNodepath, lFoundNode) then begin
            pInnerText := lFoundNode.AsXmlElement().InnerText;
            exit(true);
        end;
    end;

    procedure FindElementFromXMLDocument(pXMLDocument: XmlDocument; pNodepath: Text; var pFoundElement: XmlElement): Boolean
    var
        lRootNode: XmlNode;
        lFoundNode: XmlNode;
    begin
        Clear(pFoundElement);
        GetRootNode(pXMLDocument, lRootNode);
        if FindNode(lRootNode, pNodepath, lFoundNode) then begin
            pFoundElement := lFoundNode.AsXmlElement();
            exit(true);
        end;
    end;

    procedure GetNodeInnerText(pNode: XmlNode): Text
    var
    begin
        exit(pNode.AsXmlElement().InnerText());
    end;

    procedure LoadXMLDocumentFromText(pXMLText: Text; var pXMLDocument: XmlDocument)
    begin
        if pXMLText = '' then
            exit;
        XmlDocument.ReadFrom(pXMLText, pXMLDocument);
    end;

    procedure LoadXmlNodeFromText(pXMLText: Text; var pXmlNode: XmlNode)
    var
        lXmlDocument: XmlDocument;
    begin
        LoadXMLDocumentFromText(pXMLText, lXmlDocument);
        pXmlNode := lXmlDocument.AsXmlNode();
    end;

    procedure LoadXMLDocumentFromInStream(pInStream: InStream; var pXMLDocument: XmlDocument)
    begin
        XmlDocument.ReadFrom(pInStream, pXMLDocument);
    end;

    procedure LoadXmlNodeFromInStream(pInStream: InStream; var pXmlNode: XmlNode)
    var
        lXmlDocument: XmlDocument;
    begin
        LoadXMLDocumentFromInStream(pInStream, lXmlDocument);
        pXmlNode := lXmlDocument.AsXmlNode();
    end;

    procedure RemoveNamespaces(pXmlText: Text): Text
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
    begin
        exit(XMLDOMMgt.RemoveNamespaces(pXmlText));
    end;

    procedure SetUTF88Declaration(var pXMLDocument: XmlDocument; pStandaloneTxt: Text);
    var
        lXmlDeclaration: XmlDeclaration;
    begin
        lXmlDeclaration := XmlDeclaration.Create('1.0', 'utf-8', pStandaloneTxt);
        pXMLDocument.SetDeclaration(lXmlDeclaration);
    end;

    procedure ReplaceInvalidXMLCharacters(pText: Text): Text
    var
        lText: Text;
    begin
        lText := pText;
        lText := lText.Replace('&', '&amp;');
        lText := lText.Replace('<', '&lt;');
        lText := lText.Replace('>', '&gt;');
        lText := lText.Replace('"', '&quot;');
        lText := lText.Replace('''', '&apos;');
        exit(lText);
    end;

    procedure RemoveXMLRestrictedCharacters(pXmlText: Text): Text
    var
        lXmlText: Text;
        lChar: array[30] of Char;
        lArrayLen: Integer;
        li: Integer;
    begin

        if pXmlText = '' then
            exit(pXmlText);

        lXmlText := pXmlText;

        lChar[1] := 1;
        lChar[2] := 2;
        lChar[3] := 3;
        lChar[4] := 4;
        lChar[5] := 5;
        lChar[6] := 6;
        lChar[7] := 7;
        lChar[8] := 8;
        lChar[9] := 11;
        lChar[10] := 12;
        lChar[11] := 14;
        lChar[12] := 15;
        lChar[13] := 16;
        lChar[14] := 17;
        lChar[15] := 18;
        lChar[16] := 19;
        lChar[17] := 20;
        lChar[18] := 21;
        lChar[19] := 22;
        lChar[20] := 23;
        lChar[21] := 24;
        lChar[22] := 25;
        lChar[23] := 26;
        lChar[24] := 27;
        lChar[25] := 28;
        lChar[26] := 29;
        lChar[27] := 30;
        lChar[28] := 31;
        lChar[29] := 127;

        lArrayLen := ArrayLen(lChar);
        for li := 1 to lArrayLen do
            lXmlText := DelChr(lXmlText, '=', lChar[li]);
        exit(lXmlText);
    end;
}