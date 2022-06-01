--스퀘어 시그너
local m=18453410
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,cm.pfun1,2,2,cm.pfil2,aux.Stringid(m,0))
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c,xc)
	return c:IsXyzLevel(xc,5)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
function cm.pfil2(c)
	local st=cm.square_mana
	return c:IsType(TYPE_XYZ) and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup() and aux.IsFitSquare(Group.FromCards(c),st)
		and c:GetRank()<=4
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2d7) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tfil2(c,e,tp)
	return (c:IsLoc("G") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0)
		or (c:IsLoc("M") and c:IsControlerCanBeChanged())
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("MG") and cm.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G","MG",1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("G") then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif tc:IsLoc("M") then
		e:SetCategory(CATEGORY_CONTROL)
		Duel.SOI(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsLoc("G") then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsLoc("M") and tc:IsControler(1-tp) then
			Duel.GetControl(tc,tp)
		end
	end
end