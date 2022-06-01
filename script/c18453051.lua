--코스트 퍼포먼스
local m=18453051
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"<",cm.pfun1,aux.TRUE,aux.TRUE)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetLabelObject(e1)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
cm.CardType_Order=true
function cm.val1(e,c)
	local g=c:GetMaterial()
	local label=0
	if g:IsExists(Card.IsType,1,nil,TYPE_EFFECT) then
		label=label+1
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_ORDER) then
		label=label+2
	end
	if g:IsExists(Card.IsCustomType,1,nil,CUSTOMTYPE_SQUARE) then
		label=label+4
	end
	e:SetLabel(label)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ORDER) or c:IsSummonType(SUMMON_TYPE_ORDER_L) or c:IsSummonType(SUMMON_TYPE_ORDER_R)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	local label=te:GetLabel()
	if chk==0 then
		return label>0
	end
	local cat=0
	if label&1>0 then
		cat=CATEGORY_DRAW
	end
	if label&2>0 then
		cat=CATEGORY_DESTROY
		local g=Duel.GMGroup(aux.TRUE,tp,0,"O",nil)
		Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
	end
	if label&4>0 then
		cat=CATEGORY_SPECIAL_SUMMON
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,"HG")
	end
end
function cm.ofil2(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local label=te:GetLabel()
	if label&1>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	local dg=Duel.GMGroup(aux.TRUE,tp,0,"O",nil)
	if label&2>0 and #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local og=dg:Select(tp,1,1,nil)
		Duel.HintSelection(og)
		Duel.Destroy(og,REASON_EFFECT)
	end
	local sg=Duel.GMGroup(cm.ofil2,tp,"HG",0,nil,e,tp)
	if label&4>0 and #sg>0 and Duel.GetLocCount(tp,"M")>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local og=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(og,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end