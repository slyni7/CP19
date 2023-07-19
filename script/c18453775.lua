--No matter what we breed
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","G")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function s.tfil1(c)
	return c:IsMonster() and c:IsSetCard(0x45) and c:IsAbleToHand() and c:IsType(TYPE_NORMAL)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.nfil2(c)
	return c:IsSummonType(SUMMON_TYPE_SKULL)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:IsExists(s.nfil2,1,nil)
end
function s.tfil2(c,e,tp)
	return c:IsMonster() and c:IsAbleToHand() and c:IsControler(tp) and c:IsLoc("G") and c:IsCanBeEffectTarget(e)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Group.CreateGroup()
	local tc=eg:GetFirst()
	while tc do
		local mat=tc:GetMaterial()
		if mat then
			mg:Merge(mat)
		end
		tc=eg:GetNext()
	end
	if chkc then
		return mg:IsContains(chkc) and s.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return mg:IsExists(s.tfil2,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=mg:FilterSelect(tp,s.tfil2,1,1,nil,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_TOHAND,sg,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end