--Wake Me Up When September Ends
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.pfil1,2,nil,s.pfun1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCountLimit(1,{id,1})
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function s.pfil1(c)
	return c:IsLevelAbove(1)
end
function s.pfun1(g,lc,sumtype,tp)
	return g:GetClassCount(Card.GetLevel)==1
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.cfil1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsAbleToGraveAsCost()
		and Duel.IEMCard(s.tfil1,tp,"D",0,1,nil,e,tp,c:GetRank())
end
function s.tfil1(c,e,tp,rk)
	return c:IsLevel(rk) and (c:IsAbleToHand() or (Duel.GetLocCount(tp,"M")>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		return Duel.IEMCard(s.cfil1,tp,"E",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.cfil1,tp,"E",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetRank())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SPOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil,e,tp,e:GetLabel())
	local sc=g:GetFirst()
	if sc then
		aux.ToHandOrElse(sc,tp,function(c)
			return sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and 
				Duel.GetLocCount(tp,"M")>0
		end,
		function(c)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=MakeEff(c,"S")
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			Duel.SpecialSummonComplete()
		end,
		aux.Stringid(id,0))
	end
end
local diet=Duel.IsExistingTarget
local dst=Duel.SelectTarget
function Duel.IsExistingTarget(filter,player,loc1,loc2,min,except,...)
	if s[0] then
		return diet(aux.OR(filter,function(c)
				return c:IsLoc("G") and c:IsType(TYPE_XYZ)
			end),player,loc1|LSTN("G"),loc2,min,except,...)
	else
		return diet(filter,player,loc1,loc2,min,except,...)
	end
end
function Duel.SelectTarget(selector,filter,player,loc1,loc2,min,max,except,...)
	if s[0] then
		return dst(selector,aux.OR(filter,function(c)
				return c:IsLoc("G") and c:IsType(TYPE_XYZ)
			end),player,loc1|LSTN("G"),loc2,min,max,except,...)
	else
		return dst(selector,filter,player,loc1,loc2,min,max,except,...)
	end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.tfil2(c)
	local res=c:IsType(TYPE_SPELL) and c:IsSetCard(0x95) and c:IsAbleToGraveAsCost()
	if res then
		s[0]=true
		res=c:CheckActivateEffect(false,true,true)~=nil
		s[0]=nil
	end
	return res
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	s[0]=true
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	s[0]=false
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		s[0]=true
		tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		s[0]=false
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then
		return
	end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end
