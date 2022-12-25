--디비디비☆나이트피버
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetCL(1)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","M")
	e5:SetCode(EFFECT_NIGHT_FEVER_PAYLP_TO_DRAW)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTR(1,0)
	e5:SetCondition(s.con5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_NIGHT_FEVER_DISCARD_TO_RECOVER)
	c:RegisterEffect(e6)
end
function s.tfil1(c)
	return c:IsSetCard("나이트피버") and c:IsAbleToHand() and c:IsMonster() and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.tfil4(c)
	return c:IsSetCard("나이트피버") and c:IsFaceup() and c:IsCanTurnSet()
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(tp) and s.tfil4(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil4,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.STarget(tp,s.tfil4,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_POSITION,g,1,0,0)
end
function s.ofil4(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0 then
		g:AddCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SMCard(tp,s.ofil4,tp,"M","M",0,1,nil)
		if #sg>0 then
			Duel.BreakEffect()
			local sc=sg:GetFirst()
			if Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)>0 then
				if sc:IsSetCard("나이트피버") then
					g:Merge(sg)
				end
			end
		end
		g:KeepAlive()
		local fid=e:GetFieldID()
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(id-1,RESET_EVENT+RESETS_STANDARD,0,0,fid)
			tc=g:GetNext()
		end
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabelObject(g)
		e1:SetLabel(fid)
		e1:SetCondition(s.ocon41)
		e1:SetOperation(s.oop41)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.onfil41(c,fid)
	return c:GetFlagEffectLabel(id-1)==fid and c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function s.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=e:GetLabelObject()
	if g:FilterCount(s.onfil41,nil,fid)==0 then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return re:IsActiveType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function s.oop41(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=e:GetLabelObject()
	local sg=g:Filter(s.onfil41,nil,fid)
	if #sg>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
	end
end
function s.con5(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0
end