--콘트라스트 히어로 미러클 페인터
local m=18453323
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,1,1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCost(cm.cost1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTR("M",0)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tar3)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsReason(REASON_DRAW) and tc:IsType(TYPE_SPELL) then
			local te=tc:GetActivateEffect()
			local p=tc:GetControler()
			if te and te:IsHasCategory(CATEGORY_FUSION_SUMMON) then
				Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1)
			end
		end
		tc=eg:GetNext()
	end
end
function cm.cost1(e,c,tp,st)
	if st&SUMMON_TYPE_LINK~=SUMMON_TYPE_LINK then
		return true
	end
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tfil2(c)
	return c:IsCode(18453322) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.nfil3(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function cm.con3(e)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	return not g:IsExists(cm.nfil3,1,nil)
end
function cm.tar3(e,c)
	return c~=e:GetHandler()
end