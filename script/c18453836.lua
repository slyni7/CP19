--데스완구 히어로 할로위즈 아이네레이아스카
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,s.pfil1,1,1,s.pfil1,1,2,aux.TRUE,nil,nil,nil,s.pfun1)
	local e1=Fusion.AddProcMixRep(c,true,true,s.pfil2,2,3)[1]
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_DISABLE)
	e3:SetTR("M","M")
	e3:SetTarget(s.tar3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCL(1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"S","MG")
	e5:SetCode(EFFECT_ADD_CODE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetValue(CARD_EINE_KLEINE)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"STo")
	e6:SetCode(EVENT_RELEASE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_TO_GRAVE)
	WriteEff(e7,7,"N")
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e8)
	if not s.global_check then
		s.global_check=true
	end
end
function s.pfil1(c,fc,sumtype,tp)
	if c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY) then
		return true
	end
	if c:IsAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_AQUA) then
		return true
	end
	if c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_ZOMBIE) then
		return true
	end
	if c:IsHasEffect(18452720) then
		return true
	end
	return false
end
function s.pfun1(g,sc,tp)
	local t={}
	for tc in aux.Next(g) do
		local prop=0
		if tc:IsAttribute(ATTRIBUTE_LIGHT) or tc:IsRace(RACE_FAIRY) then
			prop=prop|1
		end
		if tc:IsAttribute(ATTRIBUTE_WATER) or tc:IsRace(RACE_AQUA) then
			prop=prop|2
		end
		if tc:IsAttribute(ATTRIBUTE_DARK) or tc:IsRace(RACE_ZOMBIE) then
			prop=prop|4
		end
		if tc:IsHasEffect(18452720) then
			prop=prop|7
		end
		table.insert(t,prop)
	end
	local pbit1=0
	local pbit2=0
	local pbit3=0
	if #t>=2 then
		pbit1=t[1]|t[2]
	end
	if #t==3 then
		pbit2=t[1]|t[3]
		pbit3=t[2]|t[3]
	end
	return (#g==2 and (pbit1&0x3==0x3 or pbit1&0x5==0x5 or pbit1&0x6==0x6))
		or (#g==3 and (pbit1&0x3==0x3 or pbit1&0x5==0x5 or pbit1&0x6==0x6)
			and (pbit2&0x3==0x3 or pbit2&0x5==0x5 or pbit2&0x6==0x6)
			and (pbit3&0x3==0x3 or pbit3&0x5==0x5 or pbit3&0x6==0x6))
end
function s.pfil2(c,fc,sumtype,tp,sub,mg,sg)
	local prop=0
	if c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY) then
		prop=prop|1
	end
	if c:IsAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_AQUA) then
		prop=prop|2
	end
	if c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_ZOMBIE) then
		prop=prop|4
	end
	if c:IsHasEffect(18452720) then
		prop=prop|7
	end
	if prop==0 then
		return false
	end
	if not sg then
		return true
	end
	local t={}
	local ag=sg:Clone()
	ag:AddCard(c)
	for tc in aux.Next(ag) do
		local prop=0
		if tc:IsAttribute(ATTRIBUTE_LIGHT) or tc:IsRace(RACE_FAIRY) then
			prop=prop|1
		end
		if tc:IsAttribute(ATTRIBUTE_WATER) or tc:IsRace(RACE_AQUA) then
			prop=prop|2
		end
		if tc:IsAttribute(ATTRIBUTE_DARK) or tc:IsRace(RACE_ZOMBIE) then
			prop=prop|4
		end
		if tc:IsHasEffect(18452720) then
			prop=prop|7
		end
		table.insert(t,prop)
	end
	local pbit1=0
	local pbit2=0
	local pbit3=0
	if #t>=2 then
		pbit1=t[1]|t[2]
	end
	if #t==3 then
		pbit2=t[1]|t[3]
		pbit3=t[2]|t[3]
	end
	return #ag<2 or (#ag==2 and (pbit1&0x3==0x3 or pbit1&0x5==0x5 or pbit1&0x6==0x6))
		or (#ag==3 and (pbit1&0x3==0x3 or pbit1&0x5==0x5 or pbit1&0x6==0x6)
			and (pbit2&0x3==0x3 or pbit2&0x5==0x5 or pbit2&0x6==0x6)
			and (pbit3&0x3==0x3 or pbit3&0x5==0x5 or pbit3&0x6==0x6))
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.tfil2(c,tp)
	return c:IsCode(18453755)
		and c:CheckUniqueOnField(tp,LOCATION_ONFIELD,nil)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(s.tfil2,tp,LOCATION_DECK,0,1,nil,tp)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.tfil2,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function s.tar3(e,c)
	return e:GetHandler()~=c and (c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_EARTH+ATTRIBUTE_WIND)
		or c:IsRace(RACE_FIEND+RACE_PYRO+RACE_CYBERSE))
		and c:IsType(TYPE_EFFECT)
end
function s.cfil4(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil4,tp,"OG",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SMCard(tp,s.cfil4,tp,"OG",0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end
function s.tfil4(c,e,tp)
	local prop=0
	if c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY) then
		prop=prop|1
	end
	if c:IsAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_AQUA) then
		prop=prop|2
	end
	if c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_ZOMBIE) then
		prop=prop|4
	end
	if prop==0 then
		return false
	end
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.tfil4,tp,"H",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"H")
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil4,tp,"H",0,1,1,nil,e,tp)
	if #g<1 then
		return
	end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)<1 then
		return
	end
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_ANYTIME)
	e1:SetCondition(s.ocon41)
	e1:SetOperation(s.oop41)
	Duel.RegisterEffect(e1,tp)
end
function s.ocon41(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		e:Reset()
		return false
	end
	if Duel.CheckEvent(EVENT_SUMMON,false) or Duel.CheckEvent(EVENT_SPSUMMON,false) or Duel.CheckEvent(EVENT_FLIP_SUMMON,false) then
		return false
	end
	if Duel.GetCurrentChain()==0 and Duel.GetIdleCmdPlayer()==PLAYER_NONE then
		e:SetLabel(1)
		local b1=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
		return b1 or b2
	end
end
function s.oop41(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst())
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil,nil)
		end
	end
end
function s.tfil6(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return EinereiAsukaGroups[tp]:IsExists(s.tfil6,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=EinereiAsukaGroups[tp]:FilterSelect(tp,s.tfil6,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.con7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY) and re
end