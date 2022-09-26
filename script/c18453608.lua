--쓰리 내츄럴 컬러즈
local m=18453608
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCountLimit(1,{m,1})
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	c:SetSPSummonOnce(m)
	local e4=MakeEff(c,"F","HG")
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCondition(cm.con4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.tfil1(c)
	return c:IsCode(m+1) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tfil3(c,ec)
	local att=c:GetAttribute()
	local st=ec:GetSquareMana()
	local res=false
	for i=1,#st do
		if st[i]==att then
			res=true
			break
		end
	end
	return res and c:IsFaceup()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil3,tp,"M","M",1,nil,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,cm.tfil3,tp,"M","M",1,1,nil,c)
	local tc=g:GetFirst()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabel(tc:GetAttribute())
	e1:SetValue(cm.tval31)
	c:RegisterEffect(e1)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.tval31(e,c)
	return e:GetLabel()
end
function cm.con4(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=MakeEff(c,"S")
	e1:SetDescription(3300)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LSTN("R"))
	c:RegisterEffect(e1,true)
end