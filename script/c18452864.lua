--컬러 컬렉터
local m=18452864
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.pfun1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.pfun1(g,lc)
	return g:IsExists(Card.IsCustomType,1,nil,CUSTOMTYPE_SQUARE)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function cm.tfil11(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard("컬러큐브") and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS
		and c.mana_list and #c.mana_list==1
end
function cm.tfun11(g,e,tp)
	return Duel.IEMCard(cm.tfil12,tp,"D",0,1,nil,e,tp,g)
end
function cm.tfil12(c,e,tp,g)
	local st=c.square_mana
	if st and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsLevel(#g) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		local t={}
		local tc=g:GetFirst()
		while tc do
			table.insert(t,tc.mana_list[1])
			tc=g:GetNext()
		end
		if #st~=#t then
			return false
		end
		return cm.tfun12(st,t,1)
	end
	return false
end
function cm.tfun12(st,t,i)
	if i>#st then
		return true
	end
	local res=false
	for j=1,#t do
		local col=st[i]
		if (j<2 or t[j-1]~=t[j]) and t[j]~=-1 and t[j]==col then
			local att=t[j]
			t[j]=-1
			res=cm.tfun12(st,t,i+1)
			t[j]=att
		end
		if res then
			return true
		end
	end
	return false
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil11,tp,"D",0,nil)
	if chk==0 then
		if e:GetLabel()~=10000 then
			return false
		end
		e:SetLabel(0)
		return g:CheckSubGroup(cm.tfun11,1,99,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	local sg=g:SelectSubGroup(tp,cm.tfun11,false,1,99,e,tp)
	Duel.SendtoGrave(sg,REASON_COST)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if Duel.GetLocCount(tp,"M")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SMCard(tp,cm.tfil12,tp,"D",0,1,1,nil,e,tp,g)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	g:DeleteGroup()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function cm.tfil21(c)
	return c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.tfil22(c)
	return c:IsSetCard("컬러큐브") and c:IsAbleToHand() and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	local sg=g:Filter(cm.tfil21,nil)
	local tg=Duel.GMGroup(cm.tfil22,tp,"G",0,nil)
	if chkc then
		return false
	end
	if chk==0 then
		if e:GetLabel()~=10000 then
			return false
		end
		e:SetLabel(0)
		return c:IsReleasable() and #sg>0 and #tg>0
	end
	Duel.Release(c,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local og=tg:SelectSubGroup(tp,aux.dncheck,false,1,#sg)
	Duel.SetTargetCard(og)
	Duel.SOI(0,CATEGORY_TOHAND,og,#og,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end