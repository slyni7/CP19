--시무르그 헤븐
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id-1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--Equip register
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetLabelObject(e2)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","F")
	e5:SetCode(EFFECT_SIMORGH_HEAVEN)
	e5:SetTR("M",0)
	e5:SetCondition(s.con5)
	c:RegisterEffect(e5)
end
function s.ofil1(c)
	return c:IsMonster() and c:IsSetCard(0x12d) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.ofil1,tp,"D",0,0,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.tgfilter(c,e,tp,chk)
	return c:IsSetCard(0x12d) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
		and (chk or Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute()))
end
function s.cfilter(c,att)
	return c:IsSetCard(0x12d) and not c:IsAttribute(att)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(s.tgfilter,nil,e,tp,false)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(id-1,RESET_CHAIN,0,1)
		end
		local g=e:GetLabelObject():GetLabelObject()
		if Duel.GetCurrentChain()==0 then g:Clear() end
		g:Merge(tg)
		g:Remove(function(c) return c:GetFlagEffect(id-1)==0 end,nil)
		e:GetLabelObject():SetLabelObject(g)
		if Duel.GetFlagEffect(tp,id)==0 then
			Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+id-1,e,0,tp,tp,0)
		end
	end
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject():Filter(s.tgfilter,nil,e,tp,false)
	if chkc then return g:IsContains(chkc) and s.tgfilter(chkc,e,tp,true) end
	if chk==0 then 
		Duel.ResetFlagEffect(tp,id)
		for tc in aux.Next(g) do tc:ResetFlagEffect(id) end
		return #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
	end
	if #g==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and  tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute())
		local ec=sg:GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetLabelObject(tc)
			e1:SetValue(s.eqval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SIMORGH_EGG_TOKEN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
end
function s.eqval(e,c)
	local tc=e:GetLabelObject()
	return c==tc
end
function s.con5(e)
	return e:GetHandler():GetFlagEffect(EFFECT_SIMORGH_HEAVEN)==0
end