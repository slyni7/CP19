--헤븐 다크사이트 -규리-
local m=18452853
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,cm.pfil1,3,2)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]={}
		cm[1]={}
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetCurrentChain()
	if chain<1 then
		return
	end
	local rc=re:GetHandler()
	if rc:IsReason(REASON_COST) and rc:IsLoc("G") and rc:IsPreviousLocation(LSTN("H")) then
		cm[rp][chain-1]=true
	else
		cm[rp][chain-1]=false
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local i=1
		while cm[p][i]~=nil do
			cm[p][i]=nil
			i=i+1
		end
	end
end
function cm.pfil1(c)
	return c:GetBaseAttack()==0 and c:GetBaseDefense()==1800
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tfil1(c,e,tp)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(cm.tfil1,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil1,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	return g and #g>0 and cm[tp][ev] and Duel.IsChainNegatable(ev) and rp~=tp
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end