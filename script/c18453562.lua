--쇼팽 에튀드 25-11 겨울바람
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.con1(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
	Duel.SPOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.ofil21(c)
	return c:IsSetCard(0x2f3) and c:IsFaceup()
end
function s.ofil22(c,e,tp,lv)
	return c:IsRace(RACE_INSECT) and c:IsLevelBelow(lv)
		and (c:IsAbleToHand() or (c:IsCanBeSpecialSumoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0))
end
function s.ofil23(c,tp)
	if c:IsCode(id) then
		return false
	end
	local te=c:CheckActivateEffect(false,false,false)
	return c:IsSetCard(0x2f3) and c:IsType(TYPE_SPELL)
		and (c:IsAbleToHand() or (te and te:IsActivatable(tp) and Duel.GetLocCount(tp,"S")>0))
end
function s.ofil24(c)
	return c:IsSetCard(0x2f3) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local g=Duel.GMGroup(s.ofil21,tp,"O",0,nil)
	local gct=#g
	local opsel={}
	while gct>0 do
		local b1=Duel.IEMCard(s.ofil22,tp,"D",0,1,nil,e,tp,#g) and not opsel[1]
		local b2=Duel.IEMCard(s.ofil23,tp,"D",0,1,nil,tp) and not opsel[2]
		local b3=Duel.IEMCard(s.ofil24,tp,"D",0,1,nil) and not opsel[3]
		local op=aux.SelectEffect(tp,
			{b1,aux.Stringid(id,0)},
			{b2,aux.Stringid(id,1)},
			{b3,aux.Stringid(id,2)})
		if not op then
			break
		end
		opsel[op]=true
		if op==1 then
			local sg=Duel.SMCard(tp,s.ofil22,tp,"D",0,1,1,nil,e,tp,#g)
			local sc=sg:GetFirst()
			aux.ToHandOrElse(sc,tp,
				function(sc)
					return Duel.GetLocCount(tp,"M")>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				end,
				function(sc)
					return Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				end,
				aux.Stringid(id,3))
		elseif op==2 then
			local sg=Duel.SMCard(tp,s.ofil23,tp,"D",0,1,1,nil,tp)
			local tc=sg:GetFirst()
			if tc then
				if tc:IsAbleToHand() and (not tc:CheckActivateEffect(false,false,false)
					or not tc:CheckActivateEffect(false,false,false):IsActivatable(tp) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1
					or Duel.SelectOption(tp,aux.Stringid(82710010,0),aux.Stringid(82710010,1))==0) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					local tpe=tc:GetType()
					local te=tc:GetActivateEffect()
					local co=te:GetCost()
					local tg=te:GetTarget()
					local op=te:GetOperation()
					e:SetCategory(te:GetCategory())
					e:SetProperty(te:GetProperty())
					if tc:IsType(TYPE_FIELD) then
						Duel.MoveToField(tc,tp,tp,LSTN("F"),POS_FACEUP,true)
					else
						Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
					end
					Duel.HintActivation(te)
					e:SetActiveEffect(te)
					te:UseCountLimit(tp,1,true)
					if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
						tc:CancelToGrave(false)
					end
					local res,teg,tep,tev,tre,tr,trp
					tc:CreateEffectRelation(te)
					if te:GetCode()==EVENT_CHAINING then
						local chain=Duel.GetCurrentChain()
						local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
						local cc=ce:GetHandler()
						local cg=Group.FromCards(cc)
						local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
						teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
					elseif te:GetCode()==EVENT_FREE_CHAIN then
						teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
					else
						res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
					end
					if co then
						co(te,tp,teg,tep,tev,tre,tr,trp,1)
					end
					if tg then
						tg(te,tp,teg,tep,tev,tre,tr,trp,1)
					end
					Duel.BreakEffect()
					local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					local etc=nil
					if g then
						etc=g:GetFirst()
						while etc do
							etc:CreateEffectRelation(te)
							etc=g:GetNext()
						end
					end
					if op then
						op(te,tp,teg,tep,tev,tre,tr,trp)
					end
					tc:ReleaseEffectRelation(te)
					if g then
						etc=g:GetFirst()
						while etc do
							etc:ReleaseEffectRelation(te)
							etc=g:GetNext()
						end
					end
					e:SetActiveEffect(nil)
					e:SetCategory(CATEGORY_COIN+CATEGORY_SEARCH)
					e:SetProperty(0)
					Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
				end
			end
		elseif op==3 then
			local sg=Duel.SMCard(tp,s.ofil24,tp,"D",0,1,1,nil)
			local sc=sg:GetFirst()
			aux.ToHandOrElse(sc,tp,
				function(sc)
					return sc:IsSSetable()
				end,
				function(sc)
					return Duel.SSet(tp,sc)
				end,
				aux.Stringid(id,5))
		end
		gct=gct-1
	end
end