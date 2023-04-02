--사일런트 머조리티: 1자
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_RECOVER)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetCL(1,id)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
end
s.square_mana={0x0,0x0}
s.custom_type=CUSTOMTYPE_SQUARE
function s.tfil1(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and s.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"O","O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,s.tfil1,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.ChangePosition(tc,POS_FACEDOWN)>0 then
		Duel.Recover(tp,600,REASON_EFFECT)
		tc:CancelToGrave()
	end
end
function s.nfil2(c)
	return c:IsFacedown() or not c:IsSetCard(0x2e0)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(s.nfil2,tp,"M",0,1,nil)
end
function s.cfil2(c)
	local st=c:GetSquareMana()
	if not st or #st==0 then
		return false
	end
	local res=true
	for i=1,#st do
		if st[i]~=0 then
			res=false
			break
		end
	end
	if not res then
		return false
	end
	return c:IsSetCard(0x2e0) and c:IsAbleToDeckAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost() and Duel.IEMCard(s.cfil2,tp,"G",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,s.cfil2,tp,"G",0,1,1,c)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function s.tfil2(c,e,tp)
	return c:IsSetCard(0x2e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"H",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0 and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"H")
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil2,tp,"H",0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end