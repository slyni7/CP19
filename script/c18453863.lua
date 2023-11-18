--아세리마 아리아오빗
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_POSITION)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
end
function s.nfil1(c)
	return c:IsSetCard("아세리마") and c:IsType(TYPE_PENDULUM)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil1,tp,"O",0,1,nil)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1000)
	end
	Duel.PayLPCost(tp,1000)
end
function s.tfil1(c)
	return c:IsFaceup() and (c:IsControlerCanBeChanged() or c:IsCanTurnSet())
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLoc("M") and s.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,0,"M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,s.tfil1,tp,0,"M",1,1,nil)
	Duel.SPOI(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SPOI(0,CATEGORY_POSITION,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IEMCard(s.nfil1,tp,"O",0,1,nil) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	local b1=tc:IsCanTurnSet()
	local b2=tc:IsControlerCanBeChanged()
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	elseif op==2 then
		Duel.GetControler(tc,tp,RESET_PHASE+PHASE_END,1)
	end
end